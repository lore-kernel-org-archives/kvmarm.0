Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62702257B
	for <kvmarm@lists.linux.dev>; Wed,  8 Feb 2023 14:48:56 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id be8so19497179plb.7
        for <kvmarm@lists.linux.dev>; Wed, 08 Feb 2023 06:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FFBEpHVyO7uaEXohEkZMXZFRiWaMnYer0SJSyNE2OQo=;
        b=hMOdPggyeGwA8nIQGyI3lk8r6madEiHE1tfQILTzxCiy1S7kUMUVaOhyHsVp06goap
         xu3OTi4hYwWjZUQvyadbZEP3tCnJkNTADf3pcXG10U3Bg6jMDXlkGMHqGqVwwoskxqZD
         tawgXU9UGZ0cqOWkVEH3kiqEmuD8kla7MXmbwv9628VLynYNqSAJDTBK375CkOiEJXju
         sdjTjOye77/aoufgQyQHZ+ZVVxHUrUPnqxX8duSqU938FVPItqp/CwL5e/cVkwmZk/MT
         owWkEI8ueZFmAdHcW1jyYhtr52ME/ScfkE4iQ6i34E9szGx+u+4lnFOthBjNQywWGZ1M
         jM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FFBEpHVyO7uaEXohEkZMXZFRiWaMnYer0SJSyNE2OQo=;
        b=4oOWmDY9GtEHQC8eUBf+X/r9j2dRr8t6rXa1LviQxom3OGOBqCAfIxBGheHXlIVxXq
         btp7jZzoXjpJItfbdw8qn2T3Fk8bbPZRKbces9K1PT73s5pGh0SguGdPRpXJSyY0BvkM
         t6tL29JeOcz3MVz84Lb7wtfaDfgxRaazIiJBvQ8PCZ7UdgI8jV9nG4TpZiSQnaLz9EIm
         T90hlhOuEqCkFl0nEp19ei0YiDRRUD3+Ag+GOJPZMqs4we+uy9duPuMJwdhDTlfvifKI
         oaDsRCy9Kql1MoQLhl8ai1U54sySLlOaYTSYaS8w1xsITK21jzaau+rDa2ZEbj95ZOVW
         FO8A==
X-Gm-Message-State: AO0yUKVCPkr/rw6Jf+uh5mftuaZSObJ7XoGUMOdvTskC963wDvMLiTB2
	eGqWXZ2BmGbm8ILu6kioCqCc7Q==
X-Google-Smtp-Source: AK7set+p35lGTvN8xsFLL4fqhMTQyitTRsLEsTPZ+gHzxMmxq7tY2+fV/RaR4t2O3sr/KKtToUrGwQ==
X-Received: by 2002:a17:902:e74e:b0:198:af50:e4e9 with SMTP id p14-20020a170902e74e00b00198af50e4e9mr240153plf.15.1675867735657;
        Wed, 08 Feb 2023 06:48:55 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l2-20020a170902ec0200b00199019e247csm7680677pld.207.2023.02.08.06.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 06:48:55 -0800 (PST)
Date: Wed, 8 Feb 2023 14:48:51 +0000
From: Sean Christopherson <seanjc@google.com>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>, Gavin Shan <gshan@redhat.com>,
	Steven Price <steven.price@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v2 3/6] KVM: x86: Remove the KVM_GET_NR_MMU_PAGES ioctl
Message-ID: <Y+O2U/x7zHzeVV6e@google.com>
References: <20230208140105.655814-1-thuth@redhat.com>
 <20230208140105.655814-4-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208140105.655814-4-thuth@redhat.com>

On Wed, Feb 08, 2023, Thomas Huth wrote:
> The KVM_GET_NR_MMU_PAGES ioctl is quite questionable on 64-bit hosts
> since it fails to return the full 64 bits of the value that can be
> set with the corresponding KVM_SET_NR_MMU_PAGES call. Its "long" return
> value is truncated into an "int" in the kvm_arch_vm_ioctl() function.
> 
> Since this ioctl also never has been used by userspace applications
> (QEMU, Google's internal VMM, kvmtool and CrosVM have been checked),
> it's likely the best if we remove this badly designed ioctl before
> anybody really tries to use it.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
