Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07DF1C6FE4
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 03:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747797704; cv=none; b=JtyJTe8y4kLJHu0U3LPCItURBs1xgXHZdCZK2mCaahcyniXJt8UygBFMOapRuXisykQfV+frWko4lvzjYBo2RVpNTlHuslgUq0GUmOVEx2yFiZpYsK+V0mZzQl9aOpWeN53dRHCA0jSWaB58Y8ay2Ly85Ne7+KRudk5kQTP3BiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747797704; c=relaxed/simple;
	bh=2GJVJSHxG7TNTDIWEF3lOgcb68A6g+jAddK5dW3eqKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W1IEApAj4uyO0r1G7D8Q/speDc5UwWS8lSWh+CkwdeudOL5HWpawLm1D5xHYSPgK8xnWEgqKsiMQ8iA5oCtxj5QZUQlyCy1d6RIR4ly3u68+yi1PXgbH+wPzLOvWKDLsgyspqt59vFwg/bCU6hQdXYJRAQAjMAReW1BN00OGEnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E0NkF/rt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E0NkF/rt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747797701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jUSOmA0/3Qa3aXRPXfKpDedwfKwE88WYumy/XPPRjQc=;
	b=E0NkF/rtg1DSSk/SjyINkCtqcvfdyA/jsGRDJD9E06lp95tE4ee1922NzFwdZTl7AUaLYX
	Mjg7RMbeLBvrkt2GdMW+U/EBpCU6BEMyvBU4lWe7Lmx1tDH5L0TYyQD+vHIQkdj4EmSKEu
	HVpogAlXC+lJKvoAd1extmksbblBWTg=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-qitq4SOoNT-92Epxhy_agw-1; Tue, 20 May 2025 23:21:40 -0400
X-MC-Unique: qitq4SOoNT-92Epxhy_agw-1
X-Mimecast-MFC-AGG-ID: qitq4SOoNT-92Epxhy_agw_1747797699
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-231d7f59e03so56098195ad.2
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 20:21:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747797699; x=1748402499;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jUSOmA0/3Qa3aXRPXfKpDedwfKwE88WYumy/XPPRjQc=;
        b=oVWlhrVdmsu9xCKaZr00DaLktkRTQtnynD5f1PtsPLXfThlWW1cvp/hUT1bAtVse9A
         rjqVirA7/qE6g0kpX+r/Izl03EVqH4YR4Sc8F21SrB+XJlEJgPoAGTCbHnAbGSK8Aj0f
         qz7N/U2qIuJwiVSi5aEB9BPRiwSy4xVdRUJVNxd+TiQW7QWyZuD1lvy+LkysHJlzYR6A
         ctKhCJiu3wEkSIdqJ7myT9qBJVLKHvw9nvrcUToEwvoL5hTwnZfPFJcTi4A5rDc7Mf2i
         nspSIgRouH83HroCct+6USBNyXXXn2RgWSSjg1WZ8jTF6CamBIXhnaJcl+08dzElCGp0
         NkWA==
X-Forwarded-Encrypted: i=1; AJvYcCUp8Mf7CEVjGelnZXyd2Y3/k4rOO5yCr6gmTpmlMT/QWm0oNcV0LqC0Jf5Yv3iLYGdKM2yR97k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/9YeXnXhz6isO5IOjJNtEC7iwXVK+xkcwgwWdNkql2birU5I1
	/DKZoYL8eFx9GRMOtRe9pa1Zt0n6huC0X+3KurUgywHHHMFjbPcZqY7CxJGt5RD15/vDVU0+kg1
	Qa3ILkEDSog/rO95OenrM0UNrk/lwJlmtHpwYq0iInfkrv8Gs7wEdgJGgpA==
X-Gm-Gg: ASbGncvWdnT5Vhor/j3XcZZq/oY+eWWFXB7dA0kxvU2jargjHhhPT+my5S5v/iFMKJM
	w2uuTqpk5oQt/s9BTIm1aT0l4jeZFxuixHiE+MrL+8UG5n7TQ9+V4uGDmHxb6HmsqjEttytSPIr
	RY9kU37w788FBkmkdOCTIWq6eSWuStsVcQHvhLr8kOhXI3Z6BNfz0hMZ2MihsPOCglnzAW8sOAc
	h7wdOALdHBX25oyNDXN2kEsIv5czw1oa+Aj1fP8FnRvehDR1MkJtHEqCwav+/KuTLBb3IHvJ0J+
	qGm7ov1jn3pqFmc=
X-Received: by 2002:a17:902:d481:b0:232:4f8c:1b01 with SMTP id d9443c01a7336-2324f8c1cb2mr137961365ad.43.1747797699240;
        Tue, 20 May 2025 20:21:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlhvOC0UNtRC7lIlfulUbJxFqkdOC7pIWuh5IMs24BhyaPmpuqy0MrBWfWyaOHGCOUkRmRPA==
X-Received: by 2002:a17:902:d481:b0:232:4f8c:1b01 with SMTP id d9443c01a7336-2324f8c1cb2mr137961065ad.43.1747797698773;
        Tue, 20 May 2025 20:21:38 -0700 (PDT)
Received: from [10.72.116.61] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e9784bsm83924955ad.113.2025.05.20.20.21.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 20:21:38 -0700 (PDT)
Message-ID: <79d7ee71-a68a-4cde-8796-fb42df59cfce@redhat.com>
Date: Wed, 21 May 2025 11:21:28 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 10/16] scripts: Add default arguments
 for kvmtool
To: Alexandru Elisei <alexandru.elisei@arm.com>, andrew.jones@linux.dev,
 eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
 david@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com,
 maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-11-alexandru.elisei@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-11-alexandru.elisei@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YUKwjBrG7hHUIai_EI35uBueZdUfn9RhWGA2pbxehj8_1747797699
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> kvmtool, unless told otherwise, will do its best to make sure that a kernel
> successfully boots in a virtual machine. It does things like automatically
> creating a rootfs and adding extra parameters to the kernel command line.
> This is actively harmful to kvm-unit-tests, because some tests parse the
> kernel command line and they will fail if they encounter the options added
> by kvmtool.
> 
> Fortunately for us, kvmtool commit 5613ae26b998 ("Add --nodefaults command
> line argument") addded the --nodefaults kvmtool parameter which disables
> all the implicit virtual machine configuration that cannot be disabled by
> using other parameters, like modifying the kernel command line. So always
> use --nodefaults to allow a test to run.
> 
> kvmtool can also be too verbose when running a virtual machine, and this is
> controlled by several parameters. Add those to the default kvmtool command
> line to reduce this verbosity to a minimum.
> 
> Before:
> 
> $ vm run arm/selftest.flat --cpus 2 --mem 256 --params "setup smp=2 mem=256"
> Info: # lkvm run -k arm/selftest.flat -m 256 -c 2 --name guest-5035
> Unknown subtest
> 
> EXIT: STATUS=127
> Warning: KVM compatibility warning.
>      virtio-9p device was not detected.
>      While you have requested a virtio-9p device, the guest kernel did not initialize it.
>      Please make sure that the guest kernel was compiled with CONFIG_NET_9P_VIRTIO=y enabled in .config.
> Warning: KVM compatibility warning.
>      virtio-net device was not detected.
>      While you have requested a virtio-net device, the guest kernel did not initialize it.
>      Please make sure that the guest kernel was compiled with CONFIG_VIRTIO_NET=y enabled in .config.
> Info: KVM session ended normally.
> 
> After:
> 
> $ vm run arm/selftest.flat --nodefaults --network mode=none --loglevel=warning --cpus 2 --mem 256 --params "setup smp=2 mem=256"
> PASS: selftest: setup: smp: number of CPUs matches expectation
> INFO: selftest: setup: smp: found 2 CPUs
> PASS: selftest: setup: mem: memory size matches expectation
> INFO: selftest: setup: mem: found 256 MB
> SUMMARY: 2 tests
> 
> EXIT: STATUS=1
> 
> Note that KVMTOOL_DEFAULT_OPTS can be overwritten by an environment
> variable with the same name, but it's not documented in the help string for
> run_tests.sh. This has been done on purpose, since overwritting
> KVMTOOL_DEFAULT_OPTS should only be necessary for debugging or development
> purposes.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   scripts/common.bash | 10 +++++-----
>   scripts/vmm.bash    | 13 +++++++++++++
>   2 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/common.bash b/scripts/common.bash
> index 0645235d8baa..ee0ae71948c2 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -56,7 +56,7 @@ function for_each_unittest()
>   			# because qemu interprets the first argument after
>   			# -append as a kernel parameter.
>   			test_args=""
> -			opts=""
> +			opts="${vmm_opts[$TARGET:default_opts]}"
>   			groups=""
>   			arch=""
>   			machine=""
> @@ -70,13 +70,13 @@ function for_each_unittest()
>   		elif [[ $line =~ ^test_args\ *=\ *(.*)$ ]]; then
>   			test_args="${vmm_opts[$TARGET:args]} ${BASH_REMATCH[1]}"
>   		elif [[ $TARGET = "qemu" ]] && [[ $line =~ ^(extra_params|qemu_params)\ *=\ *'"""'(.*)$ ]]; then
> -			opts=$(parse_opts ${BASH_REMATCH[2]}$'\n' $fd)
> +			opts="${vmm_opts[$TARGET:default_opts]} $(parse_opts ${BASH_REMATCH[2]}$'\n' $fd)"
>   		elif [[ $TARGET  = "qemu" ]] && [[ $line =~ ^(extra_params|qemu_params)\ *=\ *(.*)$ ]]; then
> -			opts=${BASH_REMATCH[2]}
> +			opts="${vmm_opts[$TARGET:default_opts]} ${BASH_REMATCH[2]}"
>   		elif [[ $TARGET = "kvmtool" ]] && [[ $line =~ ^kvmtool_params\ *=\ *'"""'(.*)$ ]]; then
> -			opts=$(parse_opts ${BASH_REMATCH[1]}$'\n' $fd)
> +			opts="${vmm_opts[$TARGET:default_opts]} $(parse_opts ${BASH_REMATCH[1]}$'\n' $fd)"
>   		elif [[ $TARGET = "kvmtool" ]] && [[ $line =~ ^kvmtool_params\ *=\ *(.*)$ ]]; then
> -			opts=${BASH_REMATCH[1]}
> +			opts="${vmm_opts[$TARGET:default_opts]} ${BASH_REMATCH[1]}"
>   		elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
>   			groups=${BASH_REMATCH[1]}
>   		elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
> diff --git a/scripts/vmm.bash b/scripts/vmm.bash
> index 20968f2e6b10..d24a4c4b8713 100644
> --- a/scripts/vmm.bash
> +++ b/scripts/vmm.bash
> @@ -1,5 +1,16 @@
>   source config.mak
>   
> +# The following parameters are enabled by default when running a test with
> +# kvmtool:
> +# --nodefaults: suppress VM configuration that cannot be disabled otherwise
> +#               (like modifying the supplied kernel command line). Tests that
> +#               use the command line will fail without this parameter.

Maybe change it to below is better? (Put the 'Otherwise' to the next 
paragraph)

# --nodefaults: suppress VM configuration that cannot be disabled
#               (like modifying the supplied kernel command line). 	# 
            Otherwise tests that use the command line will fail
#               without this parameter.

Others looks good to me.

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> +# --network mode=none: do not create a network device. kvmtool tries to help the
> +#               user by automatically create one, and then prints a warning
> +#               when the VM terminates if the device hasn't been initialized.
> +# --loglevel=warning: reduce verbosity
> +: "${KVMTOOL_DEFAULT_OPTS:="--nodefaults --network mode=none --loglevel=warning"}"
> +
>   ##############################################################################
>   # qemu_fixup_return_code translates the ambiguous exit status in Table1 to that
>   # in Table2.  Table3 simply documents the complete status table.
> @@ -87,12 +98,14 @@ declare -A vmm_opts=(
>   	[qemu:kernel]='-kernel'
>   	[qemu:args]='-append'
>   	[qemu:initrd]='-initrd'
> +	[qemu:default_opts]=''
>   	[qemu:fixup_return_code]=qemu_fixup_return_code
>   
>   	[kvmtool:nr_cpus]='--cpus'
>   	[kvmtool:kernel]='--kernel'
>   	[kvmtool:args]='--params'
>   	[kvmtool:initrd]='--initrd'
> +	[kvmtool:default_opts]="$KVMTOOL_DEFAULT_OPTS"
>   	[kvmtool:fixup_return_code]=kvmtool_fixup_return_code
>   )
>   

-- 
Shaoqin

