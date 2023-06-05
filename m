Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D708381
	for <kvmarm@lists.linux.dev>; Mon,  5 Jun 2023 01:32:33 +0000 (UTC)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5149aafef44so6153648a12.0
        for <kvmarm@lists.linux.dev>; Sun, 04 Jun 2023 18:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685928751; x=1688520751;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r5td+redj+BCltRLZ11fp4poQTI56kTLzT9HA93AbpE=;
        b=H21hQKMRD9Rb7Xhud2NMe3oh3m9V7MNmokvx2z41HTTNJPIzfZ0r6bumbXTmtpGxCl
         R6MJYWSw71UIp2a3Fj538Zwkhp+Uyb+0DxqQNN6tN9OO1xTWYTzChSBC1S87xTcJTJAH
         3uD0vsIIcV7cEOq/2GItHrc99Dz+HuAkgMC7LTXT19aPvxdFVjja/cx5n2nOXAExgTBS
         faBKh/Idh4XMkgkxhQF31c7ribowNjjrTx5YrJTndO0dUPRGOucYnIls5LjnfH/SJVPg
         jU5duXh2AgfDhPDVC9ym5IF06cChOvxYqMNk00f7SU5J3sKFlufPdwV4RsAFLHjxlwpW
         Qh9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685928751; x=1688520751;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r5td+redj+BCltRLZ11fp4poQTI56kTLzT9HA93AbpE=;
        b=Jhf0UnGyxs0dGp2uBj39ep3EhukBotRyLPoRizct+imf6zBVXX1p8XM1noPqrLxvKM
         I/krO4TYdlzKDS2cOjxTDwnSJvtFNJviYB9wZH5Q3TP/EPvPgWr//8rxa8W0CtsHdDRn
         vDorIE8b9v9L8eO8Q8tobtlT3Tg7GL5zrBECQurTjFkUCTlgXr8kVtlJ4vEZ4rcJ3RTy
         v9c1gczJ2gMFIrm9QeUP1D5IHijLkFFEWB75rBdmtEQXq5/JhMNPlpgtPZAMDPvZK03T
         bgoNvb66xV+r1665cyZ/1kq/s3jw9g3bDQygTwRuR7GBrrsAAQkpNL/ujp7YXISEncja
         Qctg==
X-Gm-Message-State: AC+VfDyhdHbxpmwsJ8MkeUCWi0VIUTDYT5GTQXKxFJ3+utWnE9fDcSnA
	VFMHFc54IFVdx1X4dpkfEAICP40yllBu/CWr2Il2em/XP36p+g==
X-Google-Smtp-Source: ACHHUZ4gdXqGzd1Lu4Fuf091c/amO0GubgMyGpoBGUMtDJ6ApK0W6CyPyQShfRojjYwpGrzM91iCoMxSFQOzgScrU/0=
X-Received: by 2002:aa7:d293:0:b0:514:a157:c1b0 with SMTP id
 w19-20020aa7d293000000b00514a157c1b0mr6054489edq.10.1685928751008; Sun, 04
 Jun 2023 18:32:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Xuheng Li <technicfree@gmail.com>
Date: Sun, 4 Jun 2023 21:32:20 -0400
Message-ID: <CAOBxttgrNuU33Az=MDrP8RDhFKcjZ30hUsnwxm5WP94kLGDLMg@mail.gmail.com>
Subject: Running Protected KVM on non-Android Device
To: kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi,

I am interested in pKVM and want to try it on a normal Linux distro
such as Ubuntu.

But it seems the current upstream pKVM doesn't have protection over
the VM's memory and vCPU state. I found the android-kvm tree
(https://android-kvm.googlesource.com/linux/+/refs/tags/pkvm-core-6.3)
has the protection and there's a
kvmtool(https://android-kvm.googlesource.com/kvmtool/) for launching
the VM in protected mode.

Am I looking into the right place? And, if possible, are there any
instructions on how to run the protected VM?

Any help would be appreciated!

---
Xuheng Li
