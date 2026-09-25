Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2F63783AC
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 05:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790315020; cv=none; b=Zjo7F8BjQ2eGYpoZlXvTNJ3PLoV4dUOwFMP9bDKrz4Fby/lMSQYeu5PfHBOvB2Kla/0QYiJgQIKQ+O4ymsLDLTSZEpdv4dsoz/wOjECpTx0rmTy+orG3rS1DOD5uy6MbCuX/VNmJAMjswd1Gol/eDpqjTlaycH/CDqwA8uXOYRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790315020; c=relaxed/simple;
	bh=hbUUz98Wa7UWb5Hmz8kQwpTb+XOMC+doGlgmjJrJxg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DGLOyWnxXA5PxCpx+8MS4YYgjvfmJH+MoHRzLb9sc0jWcOXsP+JQPnRK50AffSfIGmRFJRjq9xq+0XYON2T4KaX3Ez0nu2O9rr38ZRIULS87VMu5xoqX2lUtKYXBXDHyeV82RUsBt55jCo5zkl3p8UciQqY3VNLTm8HTTI3kUnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HOpw2Gwt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HOpw2Gwt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790315018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1UdrPYhk+H7Ax+M1gheQL2QtOog+I6kAluj+Jz4QTDg=;
	b=HOpw2Gwt0nETuNZSRM6E0tzSyfYLBGtK+z+SPvlpvpOcF5HwD9Dna57U3LIOjU6/Feuf72
	WSKXWvUjdNO4m+Zt4QqbTAqW++Nsuc2X4HCXP/MwQ2FSv/ChAo2ufucgkukbIDVDHgQb0T
	OfhH3ut68gptXR9E/IJt8/fhBr/F5lI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-z39EZ--QOjGdnEi-XX7Rsw-1; Fri, 25 Sep 2026 01:43:36 -0400
X-MC-Unique: z39EZ--QOjGdnEi-XX7Rsw-1
X-Mimecast-MFC-AGG-ID: z39EZ--QOjGdnEi-XX7Rsw_1790315015
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cfa4e4684bso9539465ad.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 22:43:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790315015; x=1790919815;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1UdrPYhk+H7Ax+M1gheQL2QtOog+I6kAluj+Jz4QTDg=;
        b=yvfGSWVnvNWjijw4LT/kmEy8xEEvsxweQw8E0x1ZslplaOFoRuVU8YUK2Hof095Ay1
         6Wxuhnt6KQVaNILQ9MoUr2FEYgev6Mp4ldXUvAT/l3VQ/bWFMWQQsjWKm+c/vb7qKyw3
         xuGByPGtnCafcly1qWCse0xqtjWRf9kzSyXBUx6xR0FIS7l82hln75r8uZMQnekxlOWm
         7zUK3Mqv2LVP/oAa4rNottKlOr/IE1ow610eJV8NyW7/WT4lCxeY5KQhaP4nIAPrSXTS
         wB2+OtZ+GQhLL12WT31bJNfwDeXrrNytcagQHRT1/RZtAPxq2tiE9G3BL4KXBPtszfVI
         /AYg==
X-Forwarded-Encrypted: i=1; AKwUvBzgoiZIhJsT6Z5guSDsM7yRxDUgwQWtEclXnZteqpRsHu8RLs8eKy2oM1ZUQMKzfxNtE+1q+No=@lists.linux.dev
X-Gm-Message-State: AFuF++mrwGBGZzija5C394yee8bUFIf2UxkoxeypW26Yf88+E0DwiK/v
	Bttm+FzxNvu70nz3E2PlrH0SsRLZq4+wdVoaM/izX1LbTZZkiK6WlRoG9hKvHIzPSI8V2pvsbT0
	GnxPgghiLR0RHj2NsCSnh9QWvbkGRASpiRcL9T6c6W+6VNAR/LisSGZnQWg==
X-Gm-Gg: AYBFou3BwHKbsTh0GDeQ3UslFqMogyAN3pKr3cwReUeWKzT4+XnJMqdO01enm6M1NHa
	kJWeoM7FqwW/O3mOOVkAwMihcsl1YNjrbyTzG4G1Lq18HrSYh6pBfBXhqIlR4bGbhbj6idyeIXQ
	/dk9PtQDhaIX6My+S5Ao6wtTmVnKfK2Jh6Ulu5eCrIsZEXDnc/cZMoeUbhDbXfWHakNYtBrb4E/
	GlKueWcpTUtI4+XAlcQ20BiRRipqArJtY9PHQ6gmtlcfDHrQEFhLy35Ph6cC14hFV0J7ufqbvLt
	wLJBRkWwOX99fzVF8NGgPUXP6RokGPWYdj8lmkpBQLGOU2pS+NOKtv0twXAoRGmcYBtUMaftk+F
	BTfKOSczOeSbR2V8hGIbqOQIX0DiiolmxwUFTURIlkw==
X-Received: by 2002:a17:903:22c5:b0:2dd:c100:3137 with SMTP id d9443c01a7336-2df7e2493c9mr41840375ad.51.1790315014910;
        Thu, 24 Sep 2026 22:43:34 -0700 (PDT)
X-Received: by 2002:a17:903:22c5:b0:2dd:c100:3137 with SMTP id d9443c01a7336-2df7e2493c9mr41840225ad.51.1790315014491;
        Thu, 24 Sep 2026 22:43:34 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df91443823sm4588265ad.57.2026.09.24.22.43.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 22:43:33 -0700 (PDT)
Message-ID: <295014e8-24d7-494a-8f3e-0e17794d024f@redhat.com>
Date: Fri, 25 Sep 2026 15:43:25 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 2/7] firmware: arm_rmm: Check for RMI support at init
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-3-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260924135201.850038-3-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: t7EClizx34mxdOxnbvQvZn2rqR-vqruYdDxTe1cMysc_1790315015
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/26 11:51 PM, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> Query the RMI version number and check if it is a compatible version.
> The first two feature registers are read and exposed for future code to
> use.
> 
> We only support this for Little Endian kernels, the Big Endian kernel
> support is anyway marked BROKEN and is being removed.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> v19:
>   * Read all implemented RmiFeatureRegisters - 5
>   * Use ARRAY_SIZE(rmi_feat_reg_cache) for the loop in rmi_read_features()
>   * Fold rmi_features() into rmi_read_features
>   * Fix comment for rmi_smccc_invoke()
>   * Drop default y
>   * Add retry for RMI_BLOCKED and return to caller
> v18:
>   * Always use arm_smccc_1_2_invoke() for all RMIs making sure the unsused
>     parameters are 0 - Sashiko
>   * Move rmi_features() calls away from the arm-rmi-cmds.h to rmi.c - Gavin
> v17:
>   * Rename ARM_RMM to ARM_RMM_RMI to make it easier to add Guest facing RSI
>     support, which is also in progress
> v16:
>   * Update Kconfig text to include PCIe TDISP.
>   * Export rmi_feat_reg() here rather than in a later commit.
> v15:
>   * The code is moved again, this time into the 'firmware' directory.
> v14:
>   * This moves the basic RMI setup into the 'kernel' directory. This is
>     because RMI will be used for some features outside of KVM so should
>     be available even if KVM isn't compiled in.
> ---
>   arch/arm64/Kconfig                |   1 +
>   arch/arm64/kernel/cpufeature.c    |   1 +
>   drivers/firmware/Kconfig          |   1 +
>   drivers/firmware/Makefile         |   1 +
>   drivers/firmware/arm_rmm/Kconfig  |  25 +++++++
>   drivers/firmware/arm_rmm/Makefile |   2 +
>   drivers/firmware/arm_rmm/rmi.c    | 109 ++++++++++++++++++++++++++++++
>   include/linux/arm-rmi-cmds.h      |  48 +++++++++++++
>   8 files changed, 188 insertions(+)
>   create mode 100644 drivers/firmware/arm_rmm/Kconfig
>   create mode 100644 drivers/firmware/arm_rmm/Makefile
>   create mode 100644 drivers/firmware/arm_rmm/rmi.c
>   create mode 100644 include/linux/arm-rmi-cmds.h
> 

[...]

> diff --git a/drivers/firmware/arm_rmm/Makefile b/drivers/firmware/arm_rmm/Makefile
> new file mode 100644
> index 0000000000000..65171988fdcae
> --- /dev/null
> +++ b/drivers/firmware/arm_rmm/Makefile
> @@ -0,0 +1,2 @@
> +
> +obj-$(CONFIG_ARM_RMM_RMI)	= rmi.o

Unnecessary blank line at the top in Makefile. Besides, why doesn't this come
as below? :)

obj-$(CONFIG_ARM_RMM_RMI)	+= rmi.o

Thanks,
Gavin

