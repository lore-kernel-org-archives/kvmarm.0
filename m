Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB18F16F84F
	for <kvmarm@lists.linux.dev>; Wed,  2 Oct 2024 13:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875417; cv=none; b=uNXWUP9HAr+XtuHKfILpiK5ELgUFc0GXt5PDuyRh7qXn8In7tIyCiKidICr7QwuZvdK2ubyM1QfzwEI7WpGxdOjJ2YqQ73u16JFz1YKx3hsAMbgysX45DDP7w05mUksPqfOx2tEvrUyC5oeyBoKuNEr3jladRFS7OjsWKCDnM4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875417; c=relaxed/simple;
	bh=zLNiMV67yT9azGy7S6PnQpNwUhI83M9lUz59Tp6HCUs=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=Fb+N6uCa3rPgHm1myIrkS77jpqoCWmOEonSmKdckSRQUmiz6BNSr2qe+HDunXg82AiIuJ1fuAw2nxWuPB6cGLIi4/oBpx/9+2EfGd4dvQ4T83ZgkZNqNaFENbAQSfOBNs4Fu9RYQHUHIXQUd0y8U/BbPKhp1DWya2E1sfXRgrbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rmiazht2; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rmiazht2"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c88e6926e5so4384207a12.3
        for <kvmarm@lists.linux.dev>; Wed, 02 Oct 2024 06:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727875414; x=1728480214; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SkOjV66McPBrdYUPLUsiHb1XaYfG342zQDjfw/byBOQ=;
        b=rmiazht21MLrBbfiBLF553m+yc9xGBzxbe5fT024w73DhePPqAcQ/4S4ICmH0TVH8c
         0xKEPiyQpgD2cPj5KAl8Am+z0mw5sspiPL0oeKoGW3qbsK0Jqc1wKAnJ/UglU1pTA/kk
         8qa5zOB7J4eTrziMCiPTYtc0vbuG6XjsB3IDZrk1oKVcQS6VfNYvmxGzeX0X2yVUbFaZ
         v/wtQ18wQDFwkuC+SLqk97zv1iLcYk9wgmpFXnpkhCYwA2nurPtRS3fwhNOZyE4Ec0PZ
         PtWHzYNyckAD+FzeuzQRTvw9UuftbQsBl9FUj37P7PqIlLd49Zcz/9l+xEjQMF54Dyy1
         zJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727875414; x=1728480214;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SkOjV66McPBrdYUPLUsiHb1XaYfG342zQDjfw/byBOQ=;
        b=QKHV30u5vIsbDW3Th1v71XsFMOPSe88Mo0jOlb1ij8lTI/NBZF2H7pWvFs7TywmOoc
         8C6uPG4vVBwWru+CcelcCQBYTcB0N2Xm+/8my9w+F2SMUa6Z6ZY21+2EO04ZpRiS3IGH
         LVjbD3MgOr0J7F69YbDnIPOKLmCFHN2oEcN2sTcZGyaTz9l0Ujl+h7AHwOeUpJtMmtTH
         2xeJ9RO2ODVkaT7uxQLovdPrhkpLn7mp8OVJIlpwyvXVKDdylJkqZO1VC2BE+oWIM9hJ
         bpziSTfClwts4BntiNZxXP4JzZg9YHW0w0H1oevmXQGIPwIwd76YRwTeqCFZAbasx8Cg
         g3dw==
X-Gm-Message-State: AOJu0YzQhNlr7b+NUeo7cRVPYG+w+4fq+hEXUcYjWNAVOlr163NGrDGM
	CwB2aJKAOk+qDIVGYUrC6DQ95kSInKe0AH0xdbarqxe3O2SBi5di9ApyV86UGb3Rxq6n02yUcAP
	aEVQ=
X-Google-Smtp-Source: AGHT+IE4fLmIVlEyNaj9tzLG6pYHCYKw4LM0DCxao9MwpIpDu7JzoiZmjm7ZA30kAc4hMBbzb+NT3Q==
X-Received: by 2002:a17:906:4fd4:b0:a8d:2d35:3dc6 with SMTP id a640c23a62f3a-a98f8235edemr314975066b.26.1727875413983;
        Wed, 02 Oct 2024 06:23:33 -0700 (PDT)
Received: from [192.168.1.3] ([89.47.253.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c297bd32sm863387366b.185.2024.10.02.06.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2024 06:23:33 -0700 (PDT)
Message-ID: <f99c7436-502f-4f51-9a3c-c402b70bac58@linaro.org>
Date: Wed, 2 Oct 2024 14:23:32 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
Subject: [bug report] KVM: arm64: BUG when reading kcore with
 kvm-arm.mode=protected
To: kvmarm@lists.linux.dev
Cc: "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I noticed this when running the Perf tests so I'm reporting it here (I 
don't actually need kcore FWIW). I tested from 6.1 to 6.11 with the same 
results:

   # On the host:
   $ cat /proc/cmdline

   BOOT_IMAGE=/boot/vmlinuz-6.11.0-rc6+ 
root=UUID=090f43e8-dbb2-48e4-a9e2-efd6291fb21f ro 
earlycon=pl011,0x2A400000 kpti=off vfio-pci.ids=10ee:9038 
kvm-arm.mode=protected

   $ sudo dd if=/proc/kcore of=/dev/null

  # Wait a few seconds

    kvm [732]: nVHE hyp BUG at: arch/arm64/kvm/hyp/nvhe/mem_protect.c:540!
    kvm [732]: nVHE call trace:
    kvm [732]:  [<ffff8000090c2654>] __kvm_nvhe_$x.158+0x44/0x80
    kvm [732]:  [<ffff8000090c88d4>] __kvm_nvhe_$x.90+0x34/0x124
    kvm [732]:  [<ffff8000090c4844>] __kvm_nvhe_$x.1+0x4c/0x84
    kvm [732]:  [<ffff8000090c3864>] __kvm_nvhe_$x.0+0x64/0x64
    kvm [732]: ---[ end nVHE call trace ]---
    kvm [732]: Hyp Offset: 0xfffeffff97e00000
    Kernel panic - not syncing: HYP panic:
    PS:a04003c9 PC:00008000712c89c8 ESR:00000000f2000800
    FAR:ffff0000712bf000 HPFAR:0000000000f12bf0 PAR:0000000000000800
    VCPU:0000000000000000
    CPU: 1 PID: 732 Comm: dd Not tainted 6.4.0+ #54
    Call trace:
     dump_backtrace+0x100/0x158
     show_stack+0x24/0x40
     dump_stack_lvl+0x60/0x80
     dump_stack+0x18/0x28
     panic+0x148/0x360
     nvhe_hyp_panic_handler+0x110/0x1a0
     _copy_to_iter+0xd8/0x520
     read_kcore_iter+0x54c/0x768
     proc_reg_read_iter+0xa0/0x118
     vfs_read+0x1b4/0x290
     ksys_read+0x80/0xf8
     __arm64_sys_read+0x28/0x40
     invoke_syscall+0x4c/0x120
     el0_svc_common+0xd0/0x120
     do_el0_svc+0x3c/0xb8
     el0_svc+0x44/0xb0
     el0t_64_sync_handler+0x84/0xf0
     el0t_64_sync+0x190/0x198
    SMP: stopping secondary CPUs
    Kernel Offset: disabled
    CPU features: 0x000000,4040180c,6400720b
    Memory Limit: none
    pstore: backend (efi_pstore) writing error (-5)
    ---[ end Kernel panic - not syncing: HYP panic:
    PS:a04003c9 PC:00008000712c89c8 ESR:00000000f2000800
    FAR:ffff0000712bf000 HPFAR:0000000000f12bf0 PAR:0000000000000800
    VCPU:0000000000000000 ]---


