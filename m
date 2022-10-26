Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9A41C06
	for <kvmarm@lists.linux.dev>; Wed, 26 Oct 2022 14:29:50 +0000 (UTC)
Received: by mail-wr1-f51.google.com with SMTP id k8so17999741wrh.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Oct 2022 07:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4LdezE8EPF95kOMABaW0r9ThuTtV2O0kq680uWey88E=;
        b=Ok05VDaKcSpVKBozXBm5ibepRtCxTgrk92eOL/U+Z1qm7rU3uv593m2JotUVOl3+7y
         8ty2vqn0xpO4P7404IFVqd+8EC3CR94GHXyss4IoOAu1q4/6jlGsQBs5Le0YkcX4z5kY
         lil/Hk8mI+XQI1lhg4POsJ7/ZvCRXhyQ/7Me139VsjGs3LfQBF/XX4sDTcT9FmIhZATt
         +WYNXykOgIawqMgwztGErtD8chjSzmSEb0AcCcFHHZP8VndPR+N+3rEX1kKAfAdJnwob
         Ipov8I9y5wU259AcmJmvSSV7pQwRJ4Atm/QaMrhRElBUdt/FTGulriWUe57AH+kS9xRZ
         gFoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4LdezE8EPF95kOMABaW0r9ThuTtV2O0kq680uWey88E=;
        b=nN7pebPhir1MvKO4JgdqZ0r1h5AAXFE55FLz7UXNUH5ZNfvE9V5QZSQJL00WmNBt10
         9Q4xhHK/k1Zx/1PXxPYQNHaHx+FcLOroOjAR1tyX0YZtSJOW1x6VeigzFM+zrCns5pe4
         lgpVfSi+l02zCfK8fRLodH7wlEb3ox2soaddF6CPesup09WKXTYl7dY3fqR29W+emC43
         mzQQa9vTpib1t9GLV9iTK5509Z32o3BSyCrwcIspBGulWlHDfTPjhil/k3/qjz6D+2kM
         IO+Szivuk+cZ1iwTUSt8wPsM8khP/DDJRt9naj6QIRjDk/ro6gMLEDTT+9ibKkPePfQp
         ny/g==
X-Gm-Message-State: ACrzQf0YE3MiuTK0oU5OFe7YZj/f5ZJ+XSTt84gJ+3OpmtcKBWBV1JJu
	Cm7D15VAkNo27qcfehASGFiJK5p9o/w92g==
X-Google-Smtp-Source: AMsMyM5rydt9URLtM82O2TZ+mlJaBDCi38t/Jo3CmXtKBZrWlDPKLy68ILHoIPqvaCtiOPzGV7D7WA==
X-Received: by 2002:adf:e192:0:b0:232:3648:776d with SMTP id az18-20020adfe192000000b002323648776dmr29817431wrb.698.1666794588850;
        Wed, 26 Oct 2022 07:29:48 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id l18-20020a05600c1d1200b003a342933727sm2348945wms.3.2022.10.26.07.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 07:29:48 -0700 (PDT)
Date: Wed, 26 Oct 2022 15:29:44 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: kvmarm@lists.linux.dev, maz@kernel.org, broonie@kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org
Subject: Hang with nVHE mode and SME
Message-ID: <Y1lEWJ7rO4m1CKWL@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi All,

I'm experiencing hangs when running a guest on a Qemu platform and a host
started with nVHE mode.

The hang occurs in 

  static void __activate_traps(struct kvm_vcpu *vcpu)
  {
      ...
      if (cpus_have_final_cap(ARM64_SME)) {
           // HANG !

No problem though with either VHE or if the host boots with arm64.nosme.

The host (and the guest) are 6.1-rc1. My Qemu is 7.1.

My Qemu setup:

     $ qemu-system-aarch64 \
      -M virt \
      -machine virtualization=true -machine virt,gic-version=3  \
      -cpu max,pauth=off -smp 1 -m 16384                 \
      -drive file=rootfs.ext4,if=none,format=raw,id=hd0 \
      -device virtio-blk-device,drive=hd0 \
      -object rng-random,filename=/dev/urandom,id=rng0 \
      -netdev user,id=eth0,hostfwd=tcp::8022-:22,hostfwd=tcp::1234-:1234 \
      -device virtio-net-pci,netdev=eth0                \
      -nographic \
      -kernel arm64/boot/Image -append "earlycon root=/dev/vda kvm-arm.mode=nvhe nokaslr" \

The guest is run with kvm-tools:

     $ lkvm run -p "break=mount arm64.nosme" -k ~/Image --force-pci

Is it a known issue?

--
Vincent
