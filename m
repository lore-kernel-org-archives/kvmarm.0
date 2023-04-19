Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267493C17
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 12:06:17 +0000 (UTC)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-3f178da21afso10621535e9.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 05:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681905976; x=1684497976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0SGp6UegVJWx6aR3RC/PZCyw5QeN9ZGCt9AfUp7rqBw=;
        b=E2qSge/3RG3k2oRg5faHcELod1zVFt2vIz4MIWnoRKRdktrusPXSwMXFKkSeDEjgtk
         jpnKMocder88erLaDhGIkk1/K+ZtZTuP6zyhR8TKRhXKDonjglvgMYpnCH4Ks6tFXwh6
         axOqyKCePso53Qo6aMymCSO33oOjfvworzd1gRfwYihIoKkhbrRmbqfOTjSrQYZKpfp4
         HMj/cUREvFIvXUCJaq9LZNG2uLDMQQ2iXVpLbIzwDDEEfh0rpDcmXKiD6/B3V/iZqqGH
         m3A7ff5GTaRrBCqmzfb5918IlxFdlfr0KLfn79ehd6PwCvg/VxV+pvLv8BqUHme/FiKf
         mnTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681905976; x=1684497976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0SGp6UegVJWx6aR3RC/PZCyw5QeN9ZGCt9AfUp7rqBw=;
        b=aa+Jx+UvfbadKs7zS6X+sEyRNP8sd5i6hu3Lk7XsDLa6ERMqJEiIO/RYLxl08W93lT
         bGsPioPYcD2FuU9ktTCl68wNxlaVI+2J6bdEgQ7pI6DaczL74N/pocejbJFaplHk2J99
         4px2yb96zrZ1qiLlPHvpxNa+DNUpOqNc7pnkH/jpT5YFruZAjkcOxwH8y6d2DSJ2GnD0
         tj9UCnitmS3cSOb/xmkvUnqAbiPg4KbE6IUGmwL1XT3jbOGzAxak7kJkIfDx81+cmeOz
         aorUVhYKgw2ut52LH5XKSAYZtwTsTWXWI4W/lIjlRhv6PnR80wD8jtiVcLMLO6vF5TPe
         MibA==
X-Gm-Message-State: AAQBX9cpqp3dHNyYf5Q9s5poaoHBykg3hkjEQ2Buw9OcBVQ40R2EeU0y
	Bfqd8KTmCEAMLzK8RCVGDYzcEA==
X-Google-Smtp-Source: AKy350biUA6SKhQarBStU1/9S3mFeGVO3Bt/tsD8dekKvDbR3BFxcT0EtVXfsJ8w1cJOBiraYJ9VDA==
X-Received: by 2002:adf:fa8b:0:b0:2ee:fc1b:b7ba with SMTP id h11-20020adffa8b000000b002eefc1bb7bamr4329401wrr.39.1681905976289;
        Wed, 19 Apr 2023 05:06:16 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c45c900b003f092f0e0a0sm3280775wmo.3.2023.04.19.05.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 05:06:15 -0700 (PDT)
Date: Wed, 19 Apr 2023 15:06:12 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Steven Price <steven.price@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Fix buffer overflow in
 kvm_arm_set_fw_reg()
Message-ID: <cfb3114d-d7d4-4f1f-82e6-7f5a9024ed7c@kili.mountain>
References: <4efbab8c-640f-43b2-8ac6-6d68e08280fe@kili.mountain>
 <861qkgkt06.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861qkgkt06.wl-maz@kernel.org>

On Wed, Apr 19, 2023 at 12:31:53PM +0100, Marc Zyngier wrote:
> Thanks for the fix. In the future, please Cc me on KVM/arm64 patches

Sorry Marc, that wasn't intentional at all.  I don't know what happened.
I have a script that I use send patches and it messed up both times.  I
will investigate and fix.

regards,
dan carpenter

