Received: from out-159.mta0.migadu.com (out-159.mta0.migadu.com [91.218.175.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D588829
	for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 23:07:38 +0000 (UTC)
Date: Mon, 23 Jan 2023 23:07:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674515249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qUa1AJwQmToXEuuS0DnlbID5SKvDia26raQcvshQqiU=;
	b=C0JMVOivHKhkAn7a7r/CDE+0kUZYz5ldnRc6m3eamkwzhJZAUXXdpqcbhQDr8jGe7KpMzW
	Z91hd/nAA/3KwLKFluzYH7SI5iuhs+kFf+NFI1h1pyQHyIWsAF6hZ4EY6euhFnqt6gytEu
	8Gh7I5yUmetVdGS05yfi6AZef/ZojR0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev,
	pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
	eric.auger@redhat.com, yuzenghui@huawei.com
Subject: Re: [PATCH 1/4] KVM: selftests: aarch64: Relax userfaultfd read vs.
 write checks
Message-ID: <Y88TLcuetXMSYyfD@google.com>
References: <20230110022432.330151-1-ricarkol@google.com>
 <20230110022432.330151-2-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110022432.330151-2-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 10, 2023 at 02:24:29AM +0000, Ricardo Koller wrote:
> Only Stage1 Page table walks (S1PTW) writing a PTE on an unmapped page
> should result in a userfaultfd write. However, the userfaultfd tests in
> page_fault_test wrongly assert that any S1PTW is a PTE write.
> 
> Fix this by relaxing the read vs. write checks in all userfaultfd handlers.
> Note that this is also an attempt to focus less on KVM (and userfaultfd)
> behavior, and more on architectural behavior. Also note that after commit
> "KVM: arm64: Fix S1PTW handling on RO memslots" the userfaultfd fault
> (S1PTW with AF on an unmaped PTE page) is actually a read: the translation
> fault that comes before the permission fault.

I certainly agree that we cannot make assertions about read v. write
when registering uffd in 'missing' mode. We probably need another test
to assert that we get write faults for hardware AF updates when using
uffd in write protect mode.

--
Thanks,
Oliver
