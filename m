Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78D346DFFA;
	Mon, 21 Sep 2026 09:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983015; cv=none; b=cIBE8lYZeCextfCOf7ZktZBCgixxLwf4v29mOpz2FGvO63nbvX+jE6xQmTcEukO9JP3yXT1oTP5xlVvhXXWAQToMRbarpv0FvKGM1qGLhOClchT25sgNdArOdWGppnQ84Ppziun5tVTWYUwRBYz+STWq43G+G5KgmQxJ24KPA4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983015; c=relaxed/simple;
	bh=Nx4WZlKJnXSyg8EFFohhZy2iio9HDYgvdXDUkRHuHFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WEprram+/EZchm4Up0FPYYB4s7HIY/NMbMC5fsm/P9VP624uD8XT2XPHfAqAgKknKCmufja14JUw9/y3MG1F/hUx49mrO/O+dFKLy77/95G8Pe4KnTif5pu5IscS2c+eeLzqPdpBGk3svNE1dKVPzkEWPYbruW34UqkGbe8TG6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TA2OKI2R; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TA2OKI2R"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A35391476;
	Mon, 21 Sep 2026 02:30:09 -0700 (PDT)
Received: from [10.0.128.141] (unknown [10.0.128.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F2EDF3F86F;
	Mon, 21 Sep 2026 02:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789983013; bh=Nx4WZlKJnXSyg8EFFohhZy2iio9HDYgvdXDUkRHuHFk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TA2OKI2R90zeFDEYscKNv8cKQQLZqlW9boTf2WEPyQACBeBtIk/4kWBcMSYfj11Ta
	 thnG2OttsvgBkI/LGT02+e0GOC2V7FMXXy0A5co47CyyZzaUYaajQ7Pk9XV/Fp6o2I
	 Q/zAfD9Z3CLDuBrRFxdUP6C7NRpPAVCz+MYTKf4o=
Message-ID: <ae243947-9d82-4b08-8e24-df0411a61a0e@arm.com>
Date: Mon, 21 Sep 2026 10:30:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 6/7] firmware: arm_rmm: Ensure the RMM has GPT entries
 for memory
Content-Language: en-GB
To: Alper Gun <alpergun@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-7-suzuki.poulose@arm.com>
 <CABpDEum16ZzLSjd7Yg2Ge6VjwL8S8xxtSs_AsqOeNT9-9FNKKQ@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CABpDEum16ZzLSjd7Yg2Ge6VjwL8S8xxtSs_AsqOeNT9-9FNKKQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/09/2026 19:23, Alper Gun wrote:
> On Sat, Sep 12, 2026 at 1:37 AM Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> [...]
>> +static int rmi_init_metadata(void)
>> +{
>> +       phys_addr_t start, end;
>> +       struct memblock_region *r;
>> +
>> +       for_each_mem_region(r) {
>> +               int ret;
>> +
>> +               /* Firmware-reserved NOMAP regions are not usable system RAM */
>> +               if (memblock_is_nomap(r))
>> +                       continue;
>> +
>> +               start = memblock_region_memory_base_pfn(r) << PAGE_SHIFT;
>> +               end = memblock_region_memory_end_pfn(r) << PAGE_SHIFT;
>> +
>> +               ret = rmi_prepare_memory(start, end);
>> +               if (ret)
>> +                       return ret;
>> +       }
> 
> Hi Suzuki,
> 
> What happens if a system has memory regions in memblock that are not
> tracked by RMM (e.g. CXL memory)?
> 
> Currently, rmi_verify_memory_tracking() returns -ENODEV for untracked
> regions, causing rmi_init_metadata() to abort and disable CCA
> system-wide.
> 
> Shouldn't rmi_init_metadata() skip untracked regions (continue) with a
> warning/info log instead of aborting? That would allow Realm support
> for conventional DRAM while leaving untracked memory for the host.

No. We can't handle RMI_ERROR_TRACKING if the Host tries to back the
Realm memory by the memory that we haven't verified. So, it is safer
to give up KVM support for now. We plan to address this in future
by introducing the dynamic tracking.

Cheers
Suzuki

> 
> Thanks,
> Alper

