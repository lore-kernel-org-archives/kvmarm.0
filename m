Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FB01FD7
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 09:18:24 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so1191267wmb.5
        for <kvmarm@lists.linux.dev>; Thu, 02 Mar 2023 01:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677748702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+v85GLUDrQ2zVLBvlWtS8ia1HQWcVPpr7GzHsjdX2Jw=;
        b=MswMY0eyIVOvB1BGlIsjT7T7ZB+Coenk8J9ktojT2m4Q1VRDdt++rgRUovNUXlnJ8+
         0n9yemw+T01QZcvWjHA+IRLf1JeQT4kgvMDTRAYyxhxbxVWsHDg9iQgAYLNOQNwzA9OF
         sDZz74KhVDusvK5O1ZzeFkSdIarEHU0F40BXnkkl9lMTBvYQ5MhVKpY3D2OmLJcBkAEy
         KcO16Kf5TQjdh+qmv8d3ljlMfUjsN/SwOUJhPHytWIHGEv2W78sjXEO3RFhRyQIfEBHP
         PMv71bBDjxuLO7cV0gbppJac2jsSFYaYorLS8teQTqi/lzN5ml/LLJzfs4CWnvoIVFYD
         TWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677748703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+v85GLUDrQ2zVLBvlWtS8ia1HQWcVPpr7GzHsjdX2Jw=;
        b=mwEEf/+j1WFNoA3PGr5RwiegVxizSoDjFYtMvXcndfN/lRl2JxKrFyt8w3g33xzVEw
         VObtIUdG2RLmn3iBc2JHPXSMc45qBa/fn6qjtIHgj7qf0/08VIWYGEc8eh4kge5TFv12
         br4xusYsEJSvL35s6yflzRR+OvdupvtrK2HQ3sjMUG/3xO2Whjt01cGvznzMIEkd5Zyx
         sSoBH7YmCH6/soFLBZD/23WUd+Hb073PKV8Kg9L3eNAQKZSk5vAMkMz7mbfdO1w4PKEq
         yPbyqjAlZEJ8nv+NSsg5Goi7QHbIN/91BQzh19J5L7YFzj6ojax1Vfgz8vR/6TVO80U8
         fQJw==
X-Gm-Message-State: AO0yUKUz3ox1wVP5CMyRk4Ztz9UGXldjLDtBW7pQY8ydiS4FDzzG9BB7
	VA4/4I+77iZT1Tj1Tel1het+tQ==
X-Google-Smtp-Source: AK7set+YPw1lyaEwaI48fxgT8GolHPnYxo9XVJyK/m4+bNoNPlN8Bml3v5HR6wybgri48X3tq2AU1w==
X-Received: by 2002:a05:600c:3d8e:b0:3ea:bc08:b55e with SMTP id bi14-20020a05600c3d8e00b003eabc08b55emr6973744wmb.25.1677748702713;
        Thu, 02 Mar 2023 01:18:22 -0800 (PST)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id x14-20020adfec0e000000b002c54536c662sm14745006wrn.34.2023.03.02.01.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 01:18:22 -0800 (PST)
Date: Thu, 2 Mar 2023 09:18:24 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, James Morse <james.morse@arm.com>,
	Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Steven Price <steven.price@arm.com>, Thomas Huth <thuth@redhat.com>,
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
Message-ID: <ZABp4KhrhsHcKmh2@myrica>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <Y9PtKJ3Wicc19JF1@myrica>
 <CANW9uyud8RTkqgiL=64wV712QMxtAyubqeyCJ0vpcADJ42VqJA@mail.gmail.com>
 <Y/8Y3WLmiw6+Z5AS@myrica>
 <CANW9uysnvGCwANu+_6dp9+3rvHGOkThT9d0K2qpQV4exdmYWoA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANW9uysnvGCwANu+_6dp9+3rvHGOkThT9d0K2qpQV4exdmYWoA@mail.gmail.com>

On Thu, Mar 02, 2023 at 07:12:24AM +0900, Itaru Kitayama wrote:
> On Wed, Mar 1, 2023 at 6:20 PM Jean-Philippe Brucker
> <jean-philippe@linaro.org> wrote:
> >
> > Hi Itaru,
> >
> > On Wed, Mar 01, 2023 at 08:35:05AM +0900, Itaru Kitayama wrote:
> > > Hi Jean,
> > > I've tried your series in Real on CCA Host, but the KVM arch init
> > > emits an Invalid argument error and terminates.
> >
> > Do you know which call returns this error?  Normally the RMEGuest support
> > should print more detailed errors. Are you able to launch normal guests
> > (without the rme-guest object and confidential-guest-support machine
> > parameter)?  Could you give the complete QEMU command-line?
> 
> No, I cant say which. Yes, the CCA-capable QEMU boots if I don't set
> RME-related options.
> 
> Here's mine (based upon your command-line):
> qemu-system-aarch64 -cpu host -accel kvm -machine
> virt,gic-version=3,confidential-guest-support=rme0 -smp 2 -m 256M
> -nographic -object rme-guest,id=rme0,measurement-algo=sha512 -kernel
> Image -initrd rootfs.ext2 -append 'console=ttyAMA0 earlycon'
> -overcommit mem-lock=on

Thank you, this works on my setup so I'm not sure what's wrong. Check that
KVM initialized successfully, with this in the host kernel log:
"[    0.267019] kvm [1]: Using prototype RMM support (version 56.0)"

Next step would be to find out where the EINVAL comes from, with printfs
or GDB. This seems rather specific so I'll email you directly to avoid
filling up everyone's inbox.

Thanks,
Jean
