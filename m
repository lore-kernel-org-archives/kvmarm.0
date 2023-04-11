Received: from out-50.mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE64B4436
	for <kvmarm@lists.linux.dev>; Tue, 11 Apr 2023 08:58:19 +0000 (UTC)
Date: Tue, 11 Apr 2023 10:58:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1681203497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tYQNARfOa8tbEcaqHz6ILgvSCbmZ1g80hA9Tr6Qv/7s=;
	b=neUyHC2H2EsgiXEob5Mtj9hBifKo5nO/AW+si/QiXgKpMGVBSXS6fKnfwNsh5oUKuyF78L
	DUFGK9EJGWKuLswoWD4ZB5wdvUzRTogHYq8CcRFcDPN4wjxdzuiDVukunMGou81d2jatm+
	+LQm1blIm0+lxk8up+SHqnX/vxRknY4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 
	qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev, qemu-arm@nongnu.org, 
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [kvm-unit-tests PATCH v10 4/7] arm/tlbflush-code: TLB flush
 during code execution
Message-ID: <cw7kze4l7nhttr74j6hkojkyr4nuidxryyzvvr7vcxtu3ihi34@sy6hcuphtlff>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
 <20230307112845.452053-5-alex.bennee@linaro.org>
 <20230321150220.mfrvgxg3ebju5e6k@orel>
 <87ile2rffl.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ile2rffl.fsf@linaro.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 11, 2023 at 09:26:56AM +0100, Alex Bennée wrote:
> 
> Andrew Jones <andrew.jones@linux.dev> writes:
> 
> > On Tue, Mar 07, 2023 at 11:28:42AM +0000, Alex Bennée wrote:
> >> This adds a fairly brain dead torture test for TLB flushes intended
> >> for stressing the MTTCG QEMU build. It takes the usual -smp option for
> >> multiple CPUs.
> >> 
> <snip>
> >
> > BTW, have you tried running these tests as standalone? Since they're
> > 'nodefault' it'd be good if they work that way.
> 
> It works but I couldn't get it to skip pass the nodefault check
> automaticaly:
> 
>   env run_all_tests=1 QEMU=$HOME/lsrc/qemu.git/builds/arm.all/qemu-system-aarch64 ./tests/tcg.computed 
>   BUILD_HEAD=c9cf6e90
>   Test marked not to be run by default, are you sure (y/N)?
>

I think

 $ yes | tests/some-nodefault-test

should work.

Thanks,
drew
