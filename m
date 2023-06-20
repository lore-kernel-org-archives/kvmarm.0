Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96791857
	for <kvmarm@lists.linux.dev>; Tue, 20 Jun 2023 04:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687234473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kszkYteYWv+XtAexqVvmgcXaELYsNbs5H3NgHpBVfI0=;
	b=YtNsENjUhJyA/2xADAAkkDyb1ju2rces6Kzl6Di9uWLAwHE2+M+iCmnX5joFosB+S+KtqJ
	lnGjFnSTI649Q2YsaLnNn9qYv/cx/ABcu0cuC0qo/73+yem3yzRWyV0sn1zk7UPqwgFLuP
	5K88eKfHAEKF4IRHv5FRDqa+ZeNJBCU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-xydXslnTMyqFntC5ltty9w-1; Tue, 20 Jun 2023 00:14:31 -0400
X-MC-Unique: xydXslnTMyqFntC5ltty9w-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7624ca834b5so433004985a.0
        for <kvmarm@lists.linux.dev>; Mon, 19 Jun 2023 21:14:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687234471; x=1689826471;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kszkYteYWv+XtAexqVvmgcXaELYsNbs5H3NgHpBVfI0=;
        b=ONHfpTHCY7ygboL4WPwmFbvEu21q8vO487gVGcr6TkOkN1J7j7RgIROj2hE6z7O6Tc
         O94jg10S+Q9XfmnEvHG1NSBAtj1ieyBdnMZwc47E/yOwqXm8JLwbEAa8EgajOfZzEpfH
         NESxFwgsHMkTJYK7HTO/GSRRWqeQcJDWB0M2ywS5r2DKSr2YYYxFpWn3ZyhegZD03C/O
         7TSP+7Mf4rjzF5qXEvPhYw/6vURp6TXEzzBxiLYYTcHh3y4eUeUP3thOP3nAnFoFIOQn
         HHmVp05dfnh+POruhxX7oRzOyhWRlEpbisQoNHedSklyGdrXSNevJTv8ZsQJ3+4ZGvMt
         hLzg==
X-Gm-Message-State: AC+VfDwW8eFi52txo7kFuNVXUe5YJ5y8IPbiJ1+nZqSUhzMacItfoSTf
	QmEhJasSG4FXM0qpkHN0TRZaQc5L95aCSHH7KBq/rVfsPyQKsYpjBImBSfciRtcM3nKhoUmIHjs
	qOihe4+Hp57V62V/A
X-Received: by 2002:a05:620a:3183:b0:763:a424:5dbd with SMTP id bi3-20020a05620a318300b00763a4245dbdmr3589611qkb.2.1687234471024;
        Mon, 19 Jun 2023 21:14:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4gW1E2NFiG64aP6Q7aBRg7mPoTusI/LU7bI2NbcO70Vkb+Rj1NqHa4a0RmDzta5GE1vaqT6w==
X-Received: by 2002:a05:620a:3183:b0:763:a424:5dbd with SMTP id bi3-20020a05620a318300b00763a4245dbdmr3589589qkb.2.1687234470774;
        Mon, 19 Jun 2023 21:14:30 -0700 (PDT)
Received: from ?IPV6:2001:8003:7475:6e00:1e1e:4135:2440:ee05? ([2001:8003:7475:6e00:1e1e:4135:2440:ee05])
        by smtp.gmail.com with ESMTPSA id d16-20020a17090abf9000b00260cce91d20sm241091pjs.33.2023.06.19.21.14.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 21:14:29 -0700 (PDT)
Message-ID: <7ab8dba3-a3a2-c9e6-f78f-de77a2adc72f@redhat.com>
Date: Tue, 20 Jun 2023 14:14:22 +1000
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
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nico Boehr <nrb@linux.ibm.com>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, linux-s390@vger.kernel.org,
 lvivier@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
 imbrenda@linux.ibm.com, david@redhat.com, pbonzini@redhat.com,
 shan.gavin@gmail.com
References: <20230615062148.19883-1-gshan@redhat.com>
 <168683636810.207611.6242722390379085462@t14-nrb>
 <2a1b0e2b-a412-143a-9a57-5f2c12e8944c@redhat.com>
 <20230619-5565bc462dab3f2d6f7f26c3@orel>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230619-5565bc462dab3f2d6f7f26c3@orel>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Drew,

On 6/19/23 18:44, Andrew Jones wrote:
> On Fri, Jun 16, 2023 at 10:41:29AM +1000, Gavin Shan wrote:
>>
>> On 6/15/23 23:39, Nico Boehr wrote:
>>> Quoting Gavin Shan (2023-06-15 08:21:48)
>>>> There are extra properties for accelerators to enable the specific
>>>> features. For example, the dirty ring for KVM accelerator can be
>>>> enabled by "-accel kvm,dirty-ring-size=65536". Unfortuntely, the
>>>> extra properties for the accelerators aren't supported. It makes
>>>> it's impossible to test the combination of KVM and dirty ring
>>>> as the following error message indicates.
>>>>
>>>>     # cd /home/gavin/sandbox/kvm-unit-tests/tests
>>>>     # QEMU=/home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
>>>>       ACCEL=kvm,dirty-ring-size=65536 ./its-migration
>>>>        :
>>>>     BUILD_HEAD=2fffb37e
>>>>     timeout -k 1s --foreground 90s /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
>>>>     -nodefaults -machine virt -accel kvm,dirty-ring-size=65536 -cpu cortex-a57             \
>>>>     -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd   \
>>>>     -device pci-testdev -display none -serial stdio -kernel _NO_FILE_4Uhere_ -smp 160      \
>>>>     -machine gic-version=3 -append its-pending-migration # -initrd /tmp/tmp.gfDLa1EtWk
>>>>     qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument
>>>>
>>>> Allow to specify extra properties for accelerators. With this, the
>>>> "its-migration" can be tested for the combination of KVM and dirty
>>>> ring.
>>>>
>>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>>
>>> Maybe get_qemu_accelerator could be renamed now, since it doesn't actually "get"
>>> anything, so maybe check_qemu_accelerator?
>>>
>>> In any case, I gave it a quick run on s390x with kvm and tcg and nothing seems
>>> to break, hence for the changes in s390x:
>>>
>>> Tested-by: Nico Boehr <nrb@linux.ibm.com>
>>> Acked-by: Nico Boehr <nrb@linux.ibm.com>
>>>
>>
>> Thanks for a quick try and comment for this. I guess it's fine to keep the
>> function name as get_qemu_accelator() because $ACCEL is split into $ACCEL
>> and $ACCEL_PROPS inside it, even it don't print the accelerator name at
>> return. However, I'm also fine with check_qemu_accelerator(). Lets see
>> what's Drew's comment on this and I can post v4 to have the modified
>> function name, or an followup patch to modify the function name.
> 
> I suggested naming it set_qemu_accelerator() in the v2 review.
> 

My bad, it will be renamed to set_qemu_accelerator() in v4 :)

Thanks,
Gavin

