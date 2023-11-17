Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68423190
	for <kvmarm@lists.linux.dev>; Fri, 17 Nov 2023 00:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tl0+r6AG"
Date: Thu, 16 Nov 2023 16:18:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700180332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QD9j/IPLCC8903UMjVBCJa3RC+ypRWcjx7JiuDPe2Ls=;
	b=tl0+r6AGUUEJc6BOYRFE9I+D/a/vSp3pXhOwpx0ZY3NnJJONDKOyPyKqWvuzYpkKM2a3oU
	sf6a/H5bxRSm2Oqna0oR6uiBHC6/IZCAHnBohKwYaTrJiSHvWG3bPfEM5/X8ulBtWDAnPJ
	hTJAvSCqcoZDwF3KOg+YvGCP9fBEspI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] KVM: selftests: Initalize sem_vcpu_[cont|stop] before
 each test in dirty_log_test
Message-ID: <ZVaxXJ4xUW1eyQEL@thinky-boi>
References: <20231116093536.22256-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231116093536.22256-1-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

Hi Shaoqin,

On Thu, Nov 16, 2023 at 04:35:36AM -0500, Shaoqin Huang wrote:
> When execute the dirty_log_test on some aarch64 machine, it sometimes
> trigger the ASSERT:
> 
> ==== Test Assertion Failure ====
>   dirty_log_test.c:384: dirty_ring_vcpu_ring_full
>   pid=14854 tid=14854 errno=22 - Invalid argument
>      1  0x00000000004033eb: dirty_ring_collect_dirty_pages at dirty_log_test.c:384
>      2  0x0000000000402d27: log_mode_collect_dirty_pages at dirty_log_test.c:505
>      3   (inlined by) run_test at dirty_log_test.c:802
>      4  0x0000000000403dc7: for_each_guest_mode at guest_modes.c:100
>      5  0x0000000000401dff: main at dirty_log_test.c:941 (discriminator 3)
>      6  0x0000ffff9be173c7: ?? ??:0
>      7  0x0000ffff9be1749f: ?? ??:0
>      8  0x000000000040206f: _start at ??:?
>   Didn't continue vcpu even without ring full
> 
> The dirty_log_test fails when execute the dirty-ring test, this is
> because the sem_vcpu_cont and the sem_vcpu_stop is non-zero value when
> execute the dirty_ring_collect_dirty_pages() function. When those two
> sem_t variables are non-zero, the dirty_ring_wait_vcpu() at the
> beginning of the dirty_ring_collect_dirty_pages() will not wait for the
> vcpu to stop, but continue to execute the following code. In this case,
> before vcpu stop, if the dirty_ring_vcpu_ring_full is true, and the
> dirty_ring_collect_dirty_pages() has passed the check for the
> dirty_ring_vcpu_ring_full but hasn't execute the check for the
> continued_vcpu, the vcpu stop, and set the dirty_ring_vcpu_ring_full to
> false. Then dirty_ring_collect_dirty_pages() will trigger the ASSERT.
> 
> Why sem_vcpu_cont and sem_vcpu_stop can be non-zero value? It's because
> the dirty_ring_before_vcpu_join() execute the sem_post(&sem_vcpu_cont)
> at the end of each dirty-ring test. It can cause two cases:
> 
> 1. sem_vcpu_cont be non-zero. When we set the host_quit to be true,
>    the vcpu_worker directly see the host_quit to be true, it quit. So
>    the log_mode_before_vcpu_join() function will set the sem_vcpu_cont
>    to 1, since the vcpu_worker has quit, it won't consume it.
> 2. sem_vcpu_stop be non-zero. When we set the host_quit to be true,
>    the vcpu_worker has entered the guest state, the next time it exit
>    from guest state, it will set the sem_vcpu_stop to 1, and then see
>    the host_quit, no one will consume the sem_vcpu_stop.
> 
> When execute more and more dirty-ring tests, the sem_vcpu_cont and
> sem_vcpu_stop can be larger and larger, which makes many code paths
> don't wait for the sem_t. Thus finally cause the problem.
> 
> Fix this problem is easy, simply initialize the sem_t before every test.
> Thus whatever the state previous test left, it won't interfere the next
> test.

In your changelog you describe what sounds like a semaphore imbalance at
the time of test completion, yet your proposed fix is to just clobber
the error and start fresh.

Why not nip it at the bud and fix the logic bug instead?

-- 
Thanks,
Oliver
