Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FC636D
	for <kvmarm@lists.linux.dev>; Fri, 16 Jun 2023 00:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686876099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YVi/iSZIypb2rz83jbLdeVn8uEiZiibOapI7DmVf0UU=;
	b=SByOc6QLhCdxehGjEBSL9V7wnlW4sCv/sImwM9/Jr9+tfqk6KfKD7lWC9KiCprAbimkS+3
	FhMN6pgDEwxoCTGfAWA6RpMiidA7vHOKaKLK51kpaWClU8VOiNP8DTNkhOkLtIeJ68FwY2
	W4FZLLKAFBbTQPfndcx0J50+zJindcY=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-QdzbLASpOcS8UcqB12tk6Q-1; Thu, 15 Jun 2023 20:41:38 -0400
X-MC-Unique: QdzbLASpOcS8UcqB12tk6Q-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-25eb77bcd2fso13429a91.3
        for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 17:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686876097; x=1689468097;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YVi/iSZIypb2rz83jbLdeVn8uEiZiibOapI7DmVf0UU=;
        b=bATMiL23WC4llZvZVDON9UYSmNKfGLO4Nl3u55pjTPwDf1Q3nqGtW7wvu4w1aeSz3P
         Et5PXv2XFh+u3pxSJ14UF8McgY623/bjZ3IGc1Bbwx+GycXfcDziG9mbvpuR1BcHgnB+
         fIaLR5l1n4RBhr+2jPBtxHw7TD8aag9FBanHoYjELOfkobtnBxtNHjlmH0BzJTGxibKt
         D04iKKSwScMGcbiN27ZthtsCGtzauq96F9tyrw+pWA0w9LQidvfI2al7+yuJFGg+rHWL
         VrYk8tNJqv8Y2+D8mEYeahRI5ZVPQR7168XEbJafIU0TNH4s5um568IZVdJdFI42eTNW
         H3VA==
X-Gm-Message-State: AC+VfDw/Tv22/AF8F7ne5xO+cDQ6DGW3mg5OSRuz1Z8imF+9PLNDaQ3M
	gxXU5wQH7QX4pmCUKGgdIUYqdby7Srh99o6IhzNXIr6+PT9z8aAz/TCy9wIUlm6LN98OnKMaL/T
	Csxjnrw0p5wbZ+lD7
X-Received: by 2002:a17:90a:760c:b0:25b:d67c:6a9e with SMTP id s12-20020a17090a760c00b0025bd67c6a9emr448086pjk.16.1686876097568;
        Thu, 15 Jun 2023 17:41:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ66hZKofOAHTaqAzWgQ8l8u1H1l6VrFDfkHbJEsNGh4kvd3G3XkWzNM86Q73mR6t/1HtbJKpQ==
X-Received: by 2002:a17:90a:760c:b0:25b:d67c:6a9e with SMTP id s12-20020a17090a760c00b0025bd67c6a9emr448081pjk.16.1686876097216;
        Thu, 15 Jun 2023 17:41:37 -0700 (PDT)
Received: from ?IPV6:2001:8003:7475:6e00:1e1e:4135:2440:ee05? ([2001:8003:7475:6e00:1e1e:4135:2440:ee05])
        by smtp.gmail.com with ESMTPSA id w1-20020a17090ac98100b0025bdc3454c6sm195045pjt.8.2023.06.15.17.41.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 17:41:36 -0700 (PDT)
Message-ID: <2a1b0e2b-a412-143a-9a57-5f2c12e8944c@redhat.com>
Date: Fri, 16 Jun 2023 10:41:29 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [kvm-unit-tests PATCH v3] runtime: Allow to specify properties
 for accelerator
To: Nico Boehr <nrb@linux.ibm.com>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, linux-s390@vger.kernel.org,
 andrew.jones@linux.dev, lvivier@redhat.com, thuth@redhat.com,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
 pbonzini@redhat.com, shan.gavin@gmail.com
References: <20230615062148.19883-1-gshan@redhat.com>
 <168683636810.207611.6242722390379085462@t14-nrb>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <168683636810.207611.6242722390379085462@t14-nrb>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Nico,

On 6/15/23 23:39, Nico Boehr wrote:
> Quoting Gavin Shan (2023-06-15 08:21:48)
>> There are extra properties for accelerators to enable the specific
>> features. For example, the dirty ring for KVM accelerator can be
>> enabled by "-accel kvm,dirty-ring-size=65536". Unfortuntely, the
>> extra properties for the accelerators aren't supported. It makes
>> it's impossible to test the combination of KVM and dirty ring
>> as the following error message indicates.
>>
>>    # cd /home/gavin/sandbox/kvm-unit-tests/tests
>>    # QEMU=/home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
>>      ACCEL=kvm,dirty-ring-size=65536 ./its-migration
>>       :
>>    BUILD_HEAD=2fffb37e
>>    timeout -k 1s --foreground 90s /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
>>    -nodefaults -machine virt -accel kvm,dirty-ring-size=65536 -cpu cortex-a57             \
>>    -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd   \
>>    -device pci-testdev -display none -serial stdio -kernel _NO_FILE_4Uhere_ -smp 160      \
>>    -machine gic-version=3 -append its-pending-migration # -initrd /tmp/tmp.gfDLa1EtWk
>>    qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument
>>
>> Allow to specify extra properties for accelerators. With this, the
>> "its-migration" can be tested for the combination of KVM and dirty
>> ring.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
> 
> Maybe get_qemu_accelerator could be renamed now, since it doesn't actually "get"
> anything, so maybe check_qemu_accelerator?
> 
> In any case, I gave it a quick run on s390x with kvm and tcg and nothing seems
> to break, hence for the changes in s390x:
> 
> Tested-by: Nico Boehr <nrb@linux.ibm.com>
> Acked-by: Nico Boehr <nrb@linux.ibm.com>
> 

Thanks for a quick try and comment for this. I guess it's fine to keep 
the function name as get_qemu_accelator() because $ACCEL is split into 
$ACCEL and $ACCEL_PROPS inside it, even it don't print the accelerator 
name at return. However, I'm also fine with check_qemu_accelerator(). 
Lets see what's Drew's comment on this and I can post v4 to have the 
modified function name, or an followup patch to modify the function name.

Thanks,
Gavin

