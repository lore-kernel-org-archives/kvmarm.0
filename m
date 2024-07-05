Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6806171668
	for <kvmarm@lists.linux.dev>; Fri,  5 Jul 2024 19:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720208074; cv=none; b=UVbBrUZ313odI368EsgW74ZjHEzmWfLQYfzmHSn10/6ytegASNF+nJrAA6Qopab0GUs/CpSLBraqxnSUnS6fB9TTIjZuCN2jnBxVMho7jB6/akFchimmv+5ynxaiX2bNxmBZ8YVkpA6uUat8IZac6R0J6hGpMMO0jhkkyGSkXcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720208074; c=relaxed/simple;
	bh=oq2dwNVnjkHa+0a/z+uAGC4hLutL54benZugmgRmxGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JjyGhlRoohAuQ6+ovz5tX8eZek2cj/wPEDvSPfgTzhJRp7cjToBJ3nKYvd/TTlM0s6J6NOG90ZOlgE0ThIbYkgGmP0INsgcLzHFYmKdEd2vFGXkPabrb6y0jsTX0y1uVLnQJihWsSJlifNAgNSliN3QaWQ1mOfuKIPfXvv8ZEpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDvi2rNE; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDvi2rNE"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7f59854ace1so10014039f.2
        for <kvmarm@lists.linux.dev>; Fri, 05 Jul 2024 12:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1720208071; x=1720812871; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uMwcWC3o3HrUVeD8fd8AU+OfLGD14mr9eYqviZBaZNs=;
        b=TDvi2rNEq3BHtbBBR/ZLMwehRgyY3HtJXxuf1eB40eftyRIKmQCjvnrZ0QcRR3KQaj
         PUocAjVYpD2frbLOYwyTcPOy+xpiLJ53NGUBqYqwfz2j202gQlqkh94nb9S1R1zo8O6U
         MDyZnzHv7xCQU1Src7D93GH4OcqDSUKKxIfyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720208071; x=1720812871;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uMwcWC3o3HrUVeD8fd8AU+OfLGD14mr9eYqviZBaZNs=;
        b=GmgAt8hFjcENAk1NKiVuhILwWLs3c8u2fgx2YNcc232WH0mTK44IVlZNAhRrMcIQI1
         +wRn1PV+KVc8KppAhNvqdh98TMOK7u1sws5VU+1oGRR8CCiAayDq1Ei56gIWBoylywrJ
         eOAos1QkhXeiO3MpQLeoj+uF6IP/3RR1oMxP4prcMA0HWxIei5DE6SuTxW3PB78ARky8
         MpnQBg3zOLta+W5LpkntuidrPNkKEnOADGmR5Uc7yDBhBo1iys8Qne2ospBkrHGswbwk
         90y05Lf6TZ0zhsUo9hvEfo9UXteSdhn60/tx1KYF2LoXLrKkmyWr75vhR9wloOCcVH62
         UrLw==
X-Forwarded-Encrypted: i=1; AJvYcCVdqoJdCrgwDeJPefsOFyR/VV4Ja+t67vGsulf0KMkWeOj/IQSa/aUp/fY9uUlfHi7a4GqBEOo3dtGgnkny68/WPvWITWBl
X-Gm-Message-State: AOJu0Ywz3EWGzFi5TquZEXe8RXJ6LclUS7IAVAJIkMVdSZqbA/D7y8d0
	G77vDQa36+lrP3ZjHc4wmaRN12ESQqWk4BfjZTILohQISieKZ+EljcXQvTj4SAM=
X-Google-Smtp-Source: AGHT+IFVfC3ipyP6qVo1x6Bb2rPetYjbe/+5LIMBYOIKkl+pUyXkyZoVtgaToDJ3zLia3VmYin/naA==
X-Received: by 2002:a05:6602:6304:b0:7eb:69ec:43f2 with SMTP id ca18e2360f4ac-7f66dedecb6mr645266439f.1.1720208070940;
        Fri, 05 Jul 2024 12:34:30 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c085dd5c7dsm225863173.77.2024.07.05.12.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jul 2024 12:34:30 -0700 (PDT)
Message-ID: <cd1d4033-b4ec-408d-aff7-94330615a69a@linuxfoundation.org>
Date: Fri, 5 Jul 2024 13:34:29 -0600
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 28/29] kselftest/arm64: Add test case for POR_EL0
 signal frame records
To: Mark Brown <broonie@kernel.org>, Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, aneesh.kumar@linux.ibm.com, bp@alien8.de,
 catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
 dave.hansen@linux.intel.com, hpa@zytor.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, maz@kernel.org,
 mingo@redhat.com, mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com,
 npiggin@gmail.com, oliver.upton@linux.dev, shuah@kernel.org,
 szabolcs.nagy@arm.com, tglx@linutronix.de, will@kernel.org, x86@kernel.org,
 kvmarm@lists.linux.dev, Shuah Khan <skhan@linuxfoundation.org>
References: <20240503130147.1154804-1-joey.gouly@arm.com>
 <20240503130147.1154804-29-joey.gouly@arm.com>
 <58fb8a27-6c40-4b13-a231-b0db1c16916c@sirena.org.uk>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <58fb8a27-6c40-4b13-a231-b0db1c16916c@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/29/24 09:51, Mark Brown wrote:
> On Fri, May 03, 2024 at 02:01:46PM +0100, Joey Gouly wrote:
>> Ensure that we get signal context for POR_EL0 if and only if POE is present
>> on the system.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>

For kselftest:

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
