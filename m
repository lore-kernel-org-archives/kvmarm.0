Received: from the.earth.li (the.earth.li [93.93.131.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B6430499A
	for <kvmarm@lists.linux.dev>; Sat, 25 Apr 2026 09:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.93.131.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777108264; cv=none; b=hyaw3dLha6DWoG0wDOmeZsGRjqi/3iPpV3D0T+EU2YwX1X7dJ3tBGuqQopAki6/UVjoiUWZTBa2368gebnzVL7NF3Mmv65/iKV/nzYxHaB9wAYaE8mM+kRcWyl9WwblB3m25/0SzJrcoPY9zDSc7VgxjzK7oamYoFX1nB7TaPEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777108264; c=relaxed/simple;
	bh=aoeFCb6TbdJA35mUaAHSKWFBhTGH2XvKgroRhl3uI08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=raFyvPfas9RD23BS9o+J3I80mSj/2ozHYdKwc+78qtWnLw0kCWsjhK58g5psdJzeUwhu6UUNkFgP1vbZcIv6nbJHEngCIS0Ve2jwzklwrOQBbKkPGLdjMSVITL6CpCk9ZjgkfohUP/UH2bqGdPkOhRgTqCGJ1EroF0WZ/pnTR2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=earth.li; spf=pass smtp.mailfrom=earth.li; dkim=pass (2048-bit key) header.d=earth.li header.i=@earth.li header.b=PFouws7o; arc=none smtp.client-ip=93.93.131.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=earth.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=earth.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=earth.li header.i=@earth.li header.b="PFouws7o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
	s=the; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=j6rxqb2f278iGTGU/7sMH9FbEKwwMCCocICHWINsPdM=; b=PFouws7o5doLAYVrlIoXV/9ww5
	d4iXXPdRwm17lO0bbEn5PHzf49HJBIdNDLUsugiKPZkJ5h5nSwbHUQ1Xq2+5ABLaJ07o8zATneKKF
	w+UtT4JkUFt2KJkkfhcZ0nFa3Mqatf1iCNpJMiYXw2+7rbdwpoWMkemT2W/v4xZ5XZweXR2wG6icq
	vNY729gWq41ni9koXEUoRD+hV1lsY+neB7jIdnofYL7YzbQ0iwxIBVZ8jvgkWg3dkYsni9qGV6wRC
	pa+gbrXFIYlAcUqJw6/tPrrN5vfjA7qHE4sGi1aKYyGDEj+XAJQNrBCoow2mnGmFdsY6gE8534edj
	HMC6xTeA==;
Received: from noodles by the.earth.li with local (Exim 4.98.2)
	(envelope-from <noodles@earth.li>)
	id 1wGZ2O-00000006EIj-3k1D;
	Sat, 25 Apr 2026 10:10:57 +0100
Date: Sat, 25 Apr 2026 10:10:56 +0100
From: Jonathan McDowell <noodles@earth.li>
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	roberto.sassu@huawei.com, dmitry.kasatkin@gmail.com,
	eric.snowberg@oracle.com, jarkko@kernel.org, jgg@ziepe.ca,
	sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com,
	sebastianene@google.com, Yeoreum Yun <yeoreum.yun@arm.com>
Subject: Re: [RFC PATCH v3 2/4] security: ima: call ima_init() again at
 late_initcall_sync for defered TPM
Message-ID: <aeyFIP4Ph57LvPqe@earth.li>
References: <cover.1777036497.git.noodles@meta.com>
 <5552c20c6d6d2ae3bbb6b35124af5d98d2f79163.1777036497.git.noodles@meta.com>
 <43ff6ca37df45ed53061dad46e9d31a5118e5714.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43ff6ca37df45ed53061dad46e9d31a5118e5714.camel@linux.ibm.com>

On Fri, Apr 24, 2026 at 04:25:31PM -0400, Mimi Zohar wrote:
>Thanks, Jonathan!
>
>On Fri, 2026-04-24 at 14:24 +0100, Jonathan McDowell wrote:
>> -static int __init init_ima(void)
>> +static int __init init_ima(bool late)
>>  {
>>  	int error;
>>  
>> @@ -1247,10 +1247,26 @@ static int __init init_ima(void)
>>  		return 0;
>>  	}
>>  
>> +	/*
>> +	 * If we found the TPM during our first attempt, or we know there's no
>> +	 * TPM, nothing further to do
>> +	 */
>
>Perhaps it's just me, but the comment wording is a bit off.  Could I change it
>to: If we either found the TPM or knew there's no TPM during our first attempt,
>nothing futher to do.

No objections to that updated wording from me.

>Otherwise the patch looks good.
>
>Mimi
>
>
>> +	if (late && (ima_tpm_chip || !IS_ENABLED(CONFIG_TCG_TPM)))
>> +		return 0;
>> +
>> +	ima_tpm_chip = tpm_default_chip();
>> +	if (!ima_tpm_chip && !late && IS_ENABLED(CONFIG_TCG_TPM)) {
>> +		pr_debug("TPM not available, will try later\n");
>> +		return -EPROBE_DEFER;
>> +	}
>> +
>> +	if (!ima_tpm_chip)
>> +		pr_info("No TPM chip found, activating TPM-bypass!\n");
>> +

J.

-- 
Revd Jonathan McDowell, ULC | Run like hell!
