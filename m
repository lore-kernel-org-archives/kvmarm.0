Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A80312B79
	for <kvmarm@lists.linux.dev>; Tue, 30 Apr 2024 04:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714451498; cv=none; b=ZVmAZeRjf0sODtXKYoz7pOPkwok7iF68wwKLj/ldc3xFEFwVdn5bRkPprrQwRBHfIzQ6LxhNjIB7zMjm5brv493qdRw4MQ7s5M1q0/yEhwm776lQEg6WcM2Ok+msZzfetEIiVr27DrLOvhYtOl9kau4YthvPmZukYeeb7VNmHoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714451498; c=relaxed/simple;
	bh=29uhAEoT45o4FIk7bCIeul9Jn+bmCAUKhTM2KMG4H2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qx3r64s4RmgdvMNqBUuMRWPvzqAVxawD4Loi3saDeItO1hVKMpEE/3CeU6gXiwI+FUkDYfMTYnrahGb4M6nrZHTg3QHiJPIRXBSh3am+QFDHZVErPlVzi6p2BgMz4EWB3p7F1MdkoFNCZKwPidSPfyyNlRYKzJivgv9K9LEn0oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I/4kJZsK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I/4kJZsK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714451496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i13MtWkwJ9CzG5rHobsEqX+W2OhJEVkbAyH/jjvfJXM=;
	b=I/4kJZsKr2GtzQo4hYfKxBNmfqhz9+OUmyf06HMDhHb5DHxeHo2bbkQ6TRwB7WU7/Fci/Y
	ip/YWm60peKQGzKga6GTKMpbUHpfyUlIfp3p7JTd5y88O9PaMASHmFeRqYsMufojJRIrSk
	bCxBjAiAdkdMGp0QEI2zyxcfvBZ8dQ0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-140-GsVlz6EOP6KoGuxSiKwGKQ-1; Tue, 30 Apr 2024 00:31:35 -0400
X-MC-Unique: GsVlz6EOP6KoGuxSiKwGKQ-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1e8f59d1d9bso59371815ad.1
        for <kvmarm@lists.linux.dev>; Mon, 29 Apr 2024 21:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714451494; x=1715056294;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i13MtWkwJ9CzG5rHobsEqX+W2OhJEVkbAyH/jjvfJXM=;
        b=kmxCMT8YycmTEbe3/3EH63WLNvQHubrO694aBFHh2UKZgeeJHxk8HvW+niIbf1Wn5z
         1Hb+7oi/7/MBlYhoMo7OgXCXpRCliCKKVWVeIYeCF0e7ZLXxakC6Sx2l0Rwli4nDlyjV
         gROa6Twap1MCE9tJiFMxj+YIYmIozYo0kUfRI4KXKMxLcjcZ+4qXanN2BztWYQGfs1vm
         GDCJTSFMhO7noNwwzE/K0V15LqdpnIfWVuOrkkCz9ZAGPpVzbZPk8utJb1QfVTXfq4Oq
         xLndPk4MiPIwcs3JBzi2ZO1z9Wxiqjum21TXWfoAmQx/pWxYyPHkgeIWBE+Ypih0r+OG
         MlhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZzY5dsndTzUTsN7/x8S8n4aYZ6hHijjlnVa51H15vub4PyQNJ1SR0mdea6z+5x7cu6iAuQdZIPZftjogj3F/KYlf7q7Ag
X-Gm-Message-State: AOJu0YwC42jrJDYeVAh8POwCiAtfACwsN8gQlzgCgVnQf+bRLIDS6POH
	PQqrn0AHZeFhUCt6k1lDuYCR9Yag73JzRtXAuG6oRX6csbStm1E6TKHmGVk3xFr44aVqlDPdxyz
	qumqI5QOEcfwJyLKvIv/6ZHEILzXbi1eXcXONC9JZbPHIJaW+8Cu3aw==
X-Received: by 2002:a17:902:d2c8:b0:1e4:4000:a576 with SMTP id n8-20020a170902d2c800b001e44000a576mr14606366plc.43.1714451494082;
        Mon, 29 Apr 2024 21:31:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHAw003t6HOSoCLpW/XUCLqCM5arMxu8YIqu/zbz1Hwe4t+r/fC177o/TfutrGEBjD75Dh+aQ==
X-Received: by 2002:a17:902:d2c8:b0:1e4:4000:a576 with SMTP id n8-20020a170902d2c800b001e44000a576mr14606349plc.43.1714451493684;
        Mon, 29 Apr 2024 21:31:33 -0700 (PDT)
Received: from [192.168.68.50] ([43.252.112.88])
        by smtp.gmail.com with ESMTPSA id jv12-20020a170903058c00b001eab3baad5dsm8939394plb.4.2024.04.29.21.31.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Apr 2024 21:31:33 -0700 (PDT)
Message-ID: <fb40d212-2f70-46b3-8045-1f4d40df3f6d@redhat.com>
Date: Tue, 30 Apr 2024 14:31:22 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 13/16] arm64: arch_register_cpu() variant to check if
 an ACPI handle is now available.
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>,
 linux-pm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, x86@kernel.org, Russell King
 <linux@armlinux.org.uk>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Salil Mehta <salil.mehta@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Hanjun Guo <guohanjun@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, linuxarm@huawei.com,
 justin.he@arm.com, jianyong.wu@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Sudeep Holla <sudeep.holla@arm.com>
References: <20240426135126.12802-1-Jonathan.Cameron@huawei.com>
 <20240426135126.12802-14-Jonathan.Cameron@huawei.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240426135126.12802-14-Jonathan.Cameron@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/26/24 23:51, Jonathan Cameron wrote:
> The ARM64 architecture does not support physical CPU HP today.
> To avoid any possibility of a bug against such an architecture if defined
> in future, check for the physical CPU HP case (not present) and
> return an error on any such attempt.
> 
> On ARM64 virtual CPU Hotplug relies on the status value that can be
> queried via the AML method _STA for the CPU object.
> 
> There are two conditions in which the CPU can be registered.
> 1) ACPI disabled.
> 2) ACPI enabled and the acpi_handle is available.
>     _STA evaluates to the CPU is both enabled and present.
>     (Note that in absence of the _STA method they are always in this
>      state).
> 
> If neither of these conditions is met the CPU is not 'yet' ready
> to be used and -EPROBE_DEFER is returned.
> 
> Success occurs in the early attempt to register the CPUs if we
> are booting with DT (no concept yet of vCPU HP) if not it succeeds
> for already enabled CPUs when the ACPI Processor driver attaches to
> them.  Finally it may succeed via the CPU Hotplug code indicating that
> the CPU is now enabled.
> 
> For ACPI if CONFIG_ACPI_PROCESSOR the only path to get to
> arch_register_cpu() with that handle set is via
> acpi_processor_hot_add_init() which is only called from an ACPI bus
> scan in which _STA has already been queried there is no need to
> repeat it here. Add a comment to remind us of this in the future.
> 
> Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
> Tested-by: Miguel Luis <miguel.luis@oracle.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
> V8: No change. (tags collected only)
> ---
>   arch/arm64/kernel/smp.c | 53 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 53 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

