Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E9C517BDE;
	Mon,  7 Sep 2026 16:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788797797; cv=none; b=mvVu1FuaHrlPHUyFkVJL+UJPPa/cfI4B8X79ObKmESzlQsnkFQEOPZ6oluYyAQvF/s1nGmvv0ScYC0KoiNRPaVf6QZgdZDvPXvAOgx7uS3kkzROqFSQiZf18GXtw1BR/XFgTqpgsIb0gyP5TS+GSYrMgLtW8P8cf1GCbspXJi6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788797797; c=relaxed/simple;
	bh=B8SR9QbSa0oo+w0k7XD4miSsDCC5rlyE7oY7wq817nU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=byuNkUjBzkAyGoWOwwUZ+9Bvgd1ziJp26puJhOOpk14UxAxmEkQlVf7ClfC0sbKOEJV9GuojSEezk7FPsnvQUCJ8oKIwi5Z4jAh8CLpfcTRqoplxuBO8qdFNh6FEF4K2lbipQhI9vJ3XFtrleVxLao7miflCpo9QlX/7a8ZDVk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HHITjIVB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HHITjIVB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21DA91476;
	Mon,  7 Sep 2026 09:16:19 -0700 (PDT)
Received: from [10.57.49.168] (unknown [10.57.49.168])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10D463F528;
	Mon,  7 Sep 2026 09:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788797782; bh=B8SR9QbSa0oo+w0k7XD4miSsDCC5rlyE7oY7wq817nU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HHITjIVBrJBLlYdkumfbWwpIzvo87N7fiofuVapT3Yv3vQ7JRG5fOUzlu6BCcXAtg
	 ocXgHY24KvfyzB8znvi0bKtBTYkD5C/pq49Gm0S+CqrjCu04rKB5mB1gwL6DoMpuG/
	 0keZQrqp/x3LGgbWH6RYbBMzezLcnrczuBY4oWtU=
Message-ID: <66090600-8206-4573-a031-af50ec9a3618@arm.com>
Date: Mon, 7 Sep 2026 17:16:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 5/7] firmware: arm_rmm: Activate the RMM
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-6-suzuki.poulose@arm.com>
 <20260907101737.856E11F00A3A@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260907101737.856E11F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/09/2026 11:17, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] The macro `rmi_sro_memxfer_cmd` uses a large compound literal to initialize the SRO state, forcing the compiler to allocate a ~2.2KB temporary object on the stack.
> --
> 
> commit c773f8f03d602782404ec2f0103977a8f86f3b3e
> Author: Steven Price <steven.price@arm.com>
> 
> firmware: arm_rmm: Activate the RMM
> 
> Activate the RMM after the basic configuration. This is a memory transferring,
> stateful operation.
> 
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index 42c973c3a98bb..d969c8738efde 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
> [ ... ]
>> @@ -656,7 +657,19 @@ static int __init arm64_init_rmi(void)
>>   	if (ret)
>>   		return ret;
>>   
>> -	return 0;
>> +	/* Activate the RMM */
>> +	sro = kmalloc_obj(*sro);
>> +	if (!sro)
>> +		return -ENOMEM;
>> +
>> +	ret = rmi_rmm_activate(sro);
> 
> [Severity: Medium]
> Does expanding rmi_rmm_activate() here cause stack frame bloat in
> arm64_init_rmi()?
> 
> Looking at include/linux/arm-rmi-cmds.h, rmi_rmm_activate() calls the
> rmi_sro_memxfer_cmd() macro, which evaluates a large compound literal:
> 
> *__sro = (struct rmi_sro_state){ .regs = {__VA_ARGS__} };
> 
> This forces the compiler to allocate a ~2.2KB temporary object on the stack
> before copying it to the heap object, which defeats the purpose of the
> explicit heap allocation above. Does this risk exceeding the typical
> CONFIG_FRAME_WARN threshold of 2048 bytes on arm64 and lead to build
> warnings?

I have switched to using memset() to initialise the sro and then 
initialize the regs from the __VA_ARGS__


diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index 47c31808b8a7e..1e4dd02124ebd 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -8,6 +8,7 @@

  #include <linux/arm-smccc-rmi.h>
  #include <linux/bug.h>
+#include <linux/string.h>
  #include <linux/types.h>

  #define RMI_MAX_ADDR_LIST      256
@@ -43,7 +44,8 @@ long rmi_sro_execute(struct arm_smccc_1_2_regs *regs);

  #define rmi_sro_memxfer_cmd(sro, gfp, ...) ({                          \
         struct rmi_sro_state *__sro = (sro);                            \
-       *__sro = (struct rmi_sro_state){ .regs = {__VA_ARGS__} };       \
+       memset(__sro, 0, sizeof(*__sro));                               \
+       __sro->regs = (struct arm_smccc_1_2_regs){ __VA_ARGS__ };       \
         long __ret = rmi_sro_memxfer_execute(__sro, gfp);               \
         rmi_sro_free(__sro);                                            \
         __ret;                                                          \

Cheers
Suzuki


> 
>> +	if (ret) {
>> +		pr_err("RMM activate failed\n");
>> +		ret = ret < 0 ? ret : -ENXIO;
>> +	}
>> +
>> +	kfree(sro);
>> +	return ret;
>>   }
> 

