Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD31947F76A
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 13:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787318836; cv=none; b=tnYSqom7jtIYU3nl9fPshivl3fw7DFbyqzRE9M28xclzBCxBezwqhwtQDVDM9U3QcYxs268YzuMXCWUypuHg4sZV3K/d8jcS1qNjqzcf5L6WjKtbTh7+aJciXQ8LwcUNA430/KQtvkLE1fsSD/zFO91nydG/vECsowilQRgCIXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787318836; c=relaxed/simple;
	bh=5klepE7p4Hg1qEAbCF6RZZu8Pu13Alz4PVZPELP3bS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XUXFFrL3+AAFNxKTrRIEcar9dJZRWRH3abevSZB+aofDuT6+N5P/9TrgVjXQb5GmpL3A/zR2XsCi86fDamMFd83qeMc1ktkL/WaPNXtole1VIAk6fUbn6RtNjLOWhHJVX4VyGh9YbhXagAPq+N3HpR8PXISD/fqR4Dh7Km65q+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PYrTxUEj; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PYrTxUEj"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47fd4531020so590583f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 06:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787318830; x=1787923630; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=93TKIYVELb3f7XMDYi0bAF+lcotYrliPfpYhNsdjWuM=;
        b=PYrTxUEj+0p/cJtchSLRVWExgOwB4DhXfhM6quvlXvfmhI+AdbM2I+lbDBStNxV3jk
         7DmHiw51gjnwoHhqM1HayZs2tCoOuP3jhYXHXASlOpwMJgWP01IjbDgrxhz1nOdZIBTx
         Lh9YmV2/19loYXJ/eJQq8T7U0SEUoyh1Lsw72UUegs0fXJukuJtEkLlfTDXz94YHazoa
         u0wpKCsvbPHjVmb+BO9AVZ3E6efQQF6RjG5VnUv4ODVVgUVeHcdw2ogP4J1fS5ENvUBM
         4PVbnNXSEAq4ZanuOVPq2ZJzbaXTZByWgzr5C3HjQIbjDsqIqoPuWGXZoQoblAcGT64C
         5G6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787318830; x=1787923630;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=93TKIYVELb3f7XMDYi0bAF+lcotYrliPfpYhNsdjWuM=;
        b=KwYf74IVzowX1PWOLl/gtoch6ubijRKxhDzIGO2ntZl7Taoq7zG17x+i6/KMW3eQ2K
         86vX/tsKer/33cfiEnLA8XR6Jfp79sYJXVZJ2Ec5Loalmjacpg880dy816yqPKlghDvx
         pCmaRldGNRiZJ5zdilGBVLhttJzIRY2siSoVGw2KkP8h5obvM6jJ3+ZoRGfm9DPkRtdF
         D6nhO3TifnwQHfBTQYbwh/0/3VKqo39pXtIy+A5RIAitH3xgdjbajK/Iwc6iGELbVrgG
         Y2NnAi1/NXCH6y5CcPebGBMpFmQHtRAzFBgrQiStdQiOvctwbRnb7c8/l5bsPN4TAsLs
         8qXg==
X-Forwarded-Encrypted: i=1; AHgh+RpOAZyxoI0Y0CM5uKYdIHwtAa8ecUu9fHesXi33yUZmlkwstXdecBrn/P+WiAARqTpQPD8ZlVI=@lists.linux.dev
X-Gm-Message-State: AFuF++kEuMADV+KJyYyNK14MGL8IcgMRY7w3MiPJenmXncJCREdg2bIx
	cM+Hb5fLIksXIFVnKGgdi0DPIronws/LjA43R9SMchwMNYCr5HWokiKV
X-Gm-Gg: AR+sD12xUTCA3WOX0nHSYDFEzxs3MLgzQVg38olFdL5i4ixyraW5pb2df2Ft39nfmGx
	ejlP0d+7pNoRlzvivr/wCBv13HXIDnF+nWNe51pSkqxcLgiCn3wB/tSTtLXU9a/4jCYVrMAPUHt
	ORoQeg0TK2fPyITzIiKmULRSKRV6JnsaqHJe7IGHMSeQOr5pWn/EmdcdKLBVJte7UjFbDN6Lrjf
	8IZyYMXUlrV3fPjXVAGdAx4sH69EpuLpvSPO1LvpsUdTefrrzxq4uAQD0FYdxt7H9SibqEDZMnz
	mY1eDtkg1uLMgao2zjhcYXwo13A6KfFg1hxLFk9gAe7BuTi+6EjxqIox55L5qMJy812VwVcnaq4
	0LUdjuGUclpZVH9kvWm6MKJOrNUcHEPnmuqqU/Hvw8/zCj64sVvJ0XkCai8RvTj+UlNQ+DIeE6A
	VBLgnzFSdxlyVv0YSToIDE53TKDRvfMheQKMjpVK7A4oWTLqOxvi+JCb9NbXbcf7SzI6u1XX3jt
	Nj1QQ==
X-Received: by 2002:a05:6000:41dc:b0:482:aa2a:52f6 with SMTP id ffacd0b85a97d-482c0b41f95mr10002245f8f.1.1787318830006;
        Fri, 21 Aug 2026 06:27:10 -0700 (PDT)
Received: from [10.45.28.226] ([15.248.2.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482bf82594esm3408856f8f.29.2026.08.21.06.27.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 06:27:09 -0700 (PDT)
Message-ID: <12442106-e756-4902-b9fd-c760da04f849@gmail.com>
Date: Fri, 21 Aug 2026 14:27:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/5] KVM: arm64: Add pre_fault_memory implementation
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, pbonzini@redhat.com,
 joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
 shuah@kernel.org, corbet@lwn.net, vladimir.murzin@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 isaku.yamahata@intel.com, Jack Thomson <jackabt@amazon.com>
References: <20260612162354.73378-1-jackabt.amazon@gmail.com>
 <20260612162354.73378-3-jackabt.amazon@gmail.com> <ak5sAxb3G6hhFmBF@raptor>
 <alEXGmKiXgWPPdhF@raptor>
Content-Language: en-US
From: "Thomson, Jack" <jackabt.amazon@gmail.com>
In-Reply-To: <alEXGmKiXgWPPdhF@raptor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


Hi Alex,

On 10/07/2026 5:00 pm, Alexandru Elisei wrote:
>> Does it guarantee that, after it completes and returns to userspace, the
>> address range [gpa, gpa + size] is mapped in the VM's stage 2 tables? Or
>> does it guarantee that the address range was mapped at stage 2 at some
>> point during the ioctl's execution, but parts, or all of it, might not be
>> mapped after the ioctl completes and returns to userspace?
> 
> Nevermind, spend some time thinking about it and it turns out it's
> impossible for KVM to guarantee that the memory is still mapped after the
> ioctls returns.  So I answered my own question, thanks.
> 
> Alex
> 

Yeah it's best effort, as if a vCPU had faulted the range itself. This
could be undone by an invalidation or memslot update. The value is in
the common cast (for us, post-copy migration) the guest doesn't pay the
stage-2 fault fault cost at run time.

I think it would be worth me adding a sentence to the documentation
noting there is no persistance guarentee.

-- 
Thanks,
Jack
