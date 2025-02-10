Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8550626461E
	for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 23:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739231584; cv=none; b=axZO9gLEpxgyGHgY7VkfnnWyWshx4DpG/XeX/q56xZC46dCl1vAD21eUfHTuA4NKIGFkz6Jvl5Gmo/vehdSL/P3cVZlFCzddFf6HLvZrv+okz3E5gybYpzWg3xk5bBVjQz26N6JDlpwrM47a1KGNKOmNbLeUI0qn9h6rgQKiXq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739231584; c=relaxed/simple;
	bh=wNE5B9eXHB/bYEdSpLcv8dqqcXrPyBqu/E3BTd03jYs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CtsxosV5XDkUviRMxZsqanJ2tSW1LtGgSH50ZJMyCHzGh9QBV1YLj6A4tlVCqRrtfDa6bWITdU4waUaqjO6k9GuK8IKo5ZPAjXuxsAJXh505HKAc6dU9y4GaS7mtNh2wbxehA+Dprp7rB5Fl3ETnekU5iHIQ3MsJw6xNWw27Bkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KuRa2UgS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KuRa2UgS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739231581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9n9MHUuomJDgMTr67ZouKycRR+Nts+RHOLWpDNWTuDE=;
	b=KuRa2UgSxDni+pglcmWn2BoJAUkdJSYYUl686JwCwxwl3aBt2RrE9f2Bn6UQYfUhXN7jbF
	FzxjfiSpFl9L6bxNcc0Kb5KRtGg76hOvMRp8bV2JcIVASBHFDZr+r890gys0wKbfXVP1f6
	fcTvJjOx7syzM84zWW64GoiDT81bYaI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-Ouf0OFcQOCuIlZ0dX2vyFQ-1; Mon, 10 Feb 2025 18:53:00 -0500
X-MC-Unique: Ouf0OFcQOCuIlZ0dX2vyFQ-1
X-Mimecast-MFC-AGG-ID: Ouf0OFcQOCuIlZ0dX2vyFQ
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6e4434d797fso160929126d6.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 15:53:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739231580; x=1739836380;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9n9MHUuomJDgMTr67ZouKycRR+Nts+RHOLWpDNWTuDE=;
        b=vROwzfAyzGKSbwFkxkPDCTi9ZLdjVyHhaBqlV9goRVZ4Rxtqm81T2i7wyK+y9NANDT
         2SQPzfVCV96oepflCMhgHdNKLQ3zo+B4vXoLYnJTMpHCF1A/nhRm9Ay7b0tJwwG9NTML
         kq2ktl+kVPA9yCbBVxx9vZIgY8f9GRnGtd+Cfcus+AO4KuCILK7kHuPNWTEiC8YOfJit
         vywNnRvj3jXJDayKp+zWD31mE5cTbA3ixwE3/U3nXYmHGiFagyWxmU1qAz61abTxGp8D
         9xRv9E/aRtF+qw3zlwmrh5pGNXW4YxiSUlhzEb7xTLJjtaflG+jr9YAK4H+C7A5PLgq3
         rDJw==
X-Gm-Message-State: AOJu0YyJeYD0K618Woijeqncpm2KW3kU85o2un+DkiZ15LS6k/pyKF3J
	QNlDhV+Pg/hvifHJWbDEu4b7iNh0CZajCE6mlkTlVzzjcK+YxKm7+sTcRNA59XK59lHLPiZcIZ5
	/Ir90krZJs4GpCcsGMdhgDCgoNvMBI8NgtLr9Dcjcvf7Nvb9YVK2rZQ==
X-Gm-Gg: ASbGncvG4lEltCqpBVgK0vtJx9Y1wiG5RCkYXA0kb4RGv5LGZSCeOb1DaKCAsOhdI2u
	w0Le1J+KWl8ofxmiK7GM8kf0goQXUVjELTrfbwBfoiUr93jQ7Xezw1LDgIYIOM+2614MDfc+zey
	1OjQWfCXbxCwLlnKx3caP3Y2i7zsdYoaXHSIofmda2PbcmKqoMtW77PJMZUlsaJmN5hnyrSwGjG
	dBA+Atme6mwJrbqCEUlxXLmLT3m5E/YcfOj1HTV+oQbH8Vj+9foHWEE0TBqZ8P4FJ6eQTDSCWzG
	wMrO
X-Received: by 2002:ad4:5f48:0:b0:6d4:1ea3:981d with SMTP id 6a1803df08f44-6e44577a219mr188090396d6.43.1739231579796;
        Mon, 10 Feb 2025 15:52:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGTZs5MDqcyEc7mfn8O43N7j152nBww16Om22OeV9BNEnRQ5CHfvHC/RIVx9CYDICeE4ROxPQ==
X-Received: by 2002:ad4:5f48:0:b0:6d4:1ea3:981d with SMTP id 6a1803df08f44-6e44577a219mr188090196d6.43.1739231579424;
        Mon, 10 Feb 2025 15:52:59 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e43bad5a7bsm52714786d6.119.2025.02.10.15.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 15:52:59 -0800 (PST)
Message-ID: <2673d55d596afff0b8241ccc806e437e2cf9d3e3.camel@redhat.com>
Subject: Re: Question about lock_all_vcpus
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org
Date: Mon, 10 Feb 2025 18:52:58 -0500
In-Reply-To: <864j11u70x.wl-maz@kernel.org>
References: <dd333b6d05e2757daf0dffa17ae9af5eb3498e05.camel@redhat.com>
	 <864j11u70x.wl-maz@kernel.org>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TK9sMMZtKgXTeIZu-A1ZE5CMQJOUJ6qxrQOzhXpTj7E_1739231580
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Mon, 2025-02-10 at 15:57 +0000, Marc Zyngier wrote:
> On Thu, 06 Feb 2025 20:08:10 +0000,
> Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > Hi!
> > 
> > KVM on ARM has this function, and it seems to be only used in a couple of places, mostly for
> > initialization.
> > 
> > We recently noticed a CI failure roughly like that:
> 
> Did you only recently noticed because you only recently started
> testing with lockdep? As far as I remember this has been there
> forever.

Hi,

I also think that this is something old, I guess our CI started to
test aarch64 kernels with debug lags enabled or something like that.

> 
> > [  328.171264] BUG: MAX_LOCK_DEPTH too low!
> > [  328.175227] turning off the locking correctness validator.
> > [  328.180726] Please attach the output of /proc/lock_stat to the bug report
> > [  328.187531] depth: 48  max: 48!
> > [  328.190678] 48 locks held by qemu-kvm/11664:
> > [  328.194957]  #0: ffff800086de5ba0 (&kvm->lock){+.+.}-{3:3}, at: kvm_ioctl_create_device+0x174/0x5b0
> > [  328.204048]  #1: ffff0800e78800b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> > [  328.212521]  #2: ffff07ffeee51e98 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> > [  328.220991]  #3: ffff0800dc7d80b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> > [  328.229463]  #4: ffff07ffe0c980b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> > [  328.237934]  #5: ffff0800a3883c78 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> > [  328.246405]  #6: ffff07fffbe480b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> > 
> > 
> > ..
> > ..
> > ..
> > ..
> > 
> > 
> > As far as I see currently MAX_LOCK_DEPTH is 48 and the number of
> > vCPUs can easily be hundreds.
> 
> 512 exactly. Both of which are pretty arbitrary limits.
> 
> > Do you think that it's possible? or know if there were any efforts
> > to get rid of lock_all_vcpus to avoid this problem? If not possible,
> > maybe we can exclude the lock_all_vcpus from the lockdep validator?
> 
> I'd be very wary of excluding any form of locking from being checked
> by lockdep, and I'd rather we bump MAX_LOCK_DEPTH up if KVM is enabled
> on arm64. it's not like anyone is going to run that in production
> anyway. task_struct may not be happy about that though.
> 
> The alternative is a full stop_machine(), and I don't think that will
> fly either.
> 
> > AFAIK, on x86 most of the similar cases where lock_all_vcpus could
> > be used are handled by assuming and enforcing that userspace will
> > call these functions prior to first vCPU is created an/or run, thus
> > the need for such locking doesn't exist.
> 
> This assertion doesn't hold on arm64, as this ordering requirement
> doesn't exist. We already have a bunch of established VMMs doing
> things in random orders (QEMU being the #1 offender), and the sad
> reality of the Linux ABI means this needs to be supported forever.

Understood.

Best regards,
	Maxim Levitsky

> 
> Thanks,
> 
> 	M.
> 


