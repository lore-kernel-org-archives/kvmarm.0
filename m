Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A31AC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 15 Feb 2022 09:01:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B357B4086F;
	Tue, 15 Feb 2022 04:01:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VQSXZrKMASnF; Tue, 15 Feb 2022 04:01:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C17F440C2B;
	Tue, 15 Feb 2022 04:01:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A5BD49DED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 16:55:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e1qEWLwgaqsQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 16:55:09 -0500 (EST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
 [209.85.221.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54CBB49B26
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 16:55:09 -0500 (EST)
Received: by mail-wr1-f41.google.com with SMTP id d27so25226965wrb.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 13:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=nbiLttF2koEHdia0Muc3aXcTveQFaK2OVXM8QEZv9wo=;
 b=malCESbecL6V85D3giKBvxwwWOI+KaZPF6O7OM8b5yufxhNJGykHOMJfy5/UGAhSCm
 KVP50/UdmtI4cB0gAHDphFAffYRhvYdqWnCfM9antJnI/Q8ocr+JGY55HHO4njdmjuFu
 ZfQZ6Abfu9l8cT6Kgdr6z+D2Qa6TdSrH4HAxZScU8PqMQJ6QjiENG3xl2k8wrEOP1Eo1
 L517rgZ0ZXacZwmWcdHrqOmjBSS/ffeBJV9+0iMWVMw8Hpuvi4iJZ5+yCAtpuSPX1AFQ
 9OsE80QCDOQM1PtcRwwZlYSC/Kj6lMZBjPEeG7yi14MggSHY1+QKkLqsaW7kwCZEiqvx
 nTbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=nbiLttF2koEHdia0Muc3aXcTveQFaK2OVXM8QEZv9wo=;
 b=xA5DC0ISrcZqNT6Ul7EiAkrbE5aiO7BsUsPi3CRnSvzZvjKXAENEgizlxt0QNcnY9I
 UpxZVHpJgfh+Hlwe/y84qj1Nke7PoD+Hk/kTjIPinXiUZnEpsiQsVyzkvVgtTIl2TpbH
 FfEggzlH4OA23XAeZnagLr9UfThoMI0IKnK3/PYAAiL3mttC1NKQVV3YPOy+65wZJrFo
 /8jRIYxmH4h2idPVKbApFuapL8p7h0t1BkdjkHzFXkODW0BY/N78p942qvNOZNP2bf1L
 QGGVKNtblaqf5nXCDGKE/RF2x0VCO2mg8KBAkHxwbN29F1WC0AEzHdr4/hxYZPOhzDne
 gIyw==
X-Gm-Message-State: AOAM531s2smVdwT2fyFnKXoItcP7hwKFzKZCdqmn7xqkme3NOCTudOVK
 Vimn6Ij+UNpz0CJtorJZcfpCjdghxo9mfuKvkIrefw==
X-Google-Smtp-Source: ABdhPJyvhIo3T8N6fTgUd1M/pEkvV0YDsl5jhb1hpiKI+wuP6iow4AQoZiQ9Dn/Yc3hyI5SNCUaLjj29aeruRas9n5A=
X-Received: by 2002:a05:6000:184e:: with SMTP id
 c14mr751860wri.577.1644875708093; 
 Mon, 14 Feb 2022 13:55:08 -0800 (PST)
MIME-Version: 1.0
References: <20220210224220.4076151-1-kaleshsingh@google.com>
 <87mtit4qw5.wl-maz@kernel.org>
In-Reply-To: <87mtit4qw5.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 14 Feb 2022 13:54:57 -0800
Message-ID: <CAC_TJvfgXSW9tQDHZ_1i31oBLKtGH6ymEDmoSemTa2ATwYkVMg@mail.gmail.com>
Subject: Re: [PATCH 0/7] KVM: arm64: Hypervisor stack enhancements
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Tue, 15 Feb 2022 04:01:17 -0500
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Will Deacon <will@kernel.org>,
 Peter Collingbourne <pcc@google.com>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 LKML <linux-kernel@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Feb 14, 2022 at 3:41 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 10 Feb 2022 22:41:41 +0000,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > This series is based on v5.17-rc3 and adds the following stack features to
> > the KVM nVHE hypervisor:
> >
> > == Hyp Stack Guard Pages ==
> >
> > Based on the technique used by arm64 VMAP_STACK to detect overflow.
> > i.e. the stack is aligned to twice its size which ensure that the
> > 'stack shift' bit of any valid SP is 0. The 'stack shift' bit can be
> > tested in the exception entry to detect overflow without corrupting GPRs.
>
> Having quickly parsed the code, this seems to only be effective for
> pKVM and the EL2-allocated stack. Is there any technical reason not to
> implement this for the much more common case of 'classic' KVM in nVHE
> mode?

Hi Marc,

No technical reason. We hadn't thought of it from that perspective.
It's a good idea, I'll look into this and repost  a new version.

Thanks,
Kalesh

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
