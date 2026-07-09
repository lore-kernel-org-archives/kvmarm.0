Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0013B95FA
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 20:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783629013; cv=none; b=Z9bcbIw7PHT63xDmNijvte3MErJiBBSLhlTD7nWJJluDk/6w8BzxNhqW+nFnnrJGJs+Pn5tui932Sq8jdLa288m3dAOn2shIQKsRZ1QznmPMhjsElFUI0r6F8P9xwr9A7+oqH0dJx9KtMBLdIIybaduAj0W1lC/q5HWJ8yqcZRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783629013; c=relaxed/simple;
	bh=Hh90mVt6XcR3iqrqcDw0knKu1XwU2GWLwg4NQnXR5F0=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=lLEUuUGptIjLvmdQ7qtiKxlprhAsIH6C85VME4A14dCcgtDPpvY5s47dY6ElZQGjX78vdjMOc6hdsAR/Z5grtAek67jUBZxPzQZSJu4s5xc90zftWAsLzsGUJEUrm9wa8ddW2cSK5QOEUXPRjF0G/tA7otRl68t0a9AyYlGgh0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SwNzkmB8; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SwNzkmB8"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-49d4cb3ca23so293667b6e.3
        for <kvmarm@lists.linux.dev>; Thu, 09 Jul 2026 13:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783629008; x=1784233808; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PzslN++gvwF111Oxj75aJ3QDVnvg6D0q7xeFijnE/DM=;
        b=SwNzkmB8LcoLZ0bl+sCZ+vlnHxywuj5lzqdznMFGhaX/9IOK4Q1Ys4Mbsb7zDTD31S
         k+aPEx/ri3iMVK9uBOk5YzrVbZ4LjH+yGMR/Ji+QXTR/rGOqEI3LdkAFEKABxCusuh0L
         CSLzP6GCssbIdAzIfz358jWbozqtPGZ9r0BK0ptZW27m7U1N4wDM6wW66CZ4c+SnQL32
         hs1wTGf9OKiJP9dR+Argdj1jIZ6UUYY5uofzJ7kTahFfCpK8MXGpWIfNNM8RQnkJ4c1j
         fYp8ioPxTH++HGGXNlrpKUKApZzTCNcyPKmLLWnnm5r+appAzSu9RXp1PVVhU42tV507
         m1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783629008; x=1784233808;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PzslN++gvwF111Oxj75aJ3QDVnvg6D0q7xeFijnE/DM=;
        b=Rr6KRHY+HhWKUOPcfGV1sSuUSgrFwTbgSCFGyqq+6k8uwcbafxAGCeGXsdzcWxewG1
         SdkPk1hfy54RWI+7ttFsmSq5hM6t8BrfibFSy7m4P3prTNOq5BaK2UYEaNrVuqL1V/xQ
         ioqbZbzgIBKEyccmMTo2UvnVGEg7DsifaHxb/yyN7zfhpGoC3129oA6MmdXU/dwGTpKI
         vFe8lUE+DWBqN4hl22KpxNeW/VrEfQMeiIe3NopPQL2wclt9thdSxAjrMOtAQwzXRmth
         AOpWg1ZzARmM75NN6APb82yvJINnDhewzvKBWHjhSfW1Py4zEjZRQ0/XVZ3cbBqNktIR
         f0rw==
X-Forwarded-Encrypted: i=1; AFNElJ+ev4+OJlMdz0z7EctltmzpRVq6mu8kvMCadhcwBzl++5vrWyDWpbLd1XY5tQwGdtN0ipruwBo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWqZhasvXas1LwPbaBW63iJyEpcIRfv5bDSTxnVF+tClcF4h0T
	kcm4oNxWj/fmdTY6NxWI+XYC9LRairnFWYJtqqcOyJ8TAPI7+aAB+KVlGtF++cwaczdFDmF0LsP
	f9x6fr7SfTBcwyhc/aIqrmJW3Uw==
X-Received: from jaaf25.prod.google.com ([2002:a05:6638:c7d9:b0:5e9:4c3:fe2b])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1a1a:b0:495:f85b:d08f with SMTP id 5614622812f47-4a20241e89cmr7170981b6e.18.1783629008168;
 Thu, 09 Jul 2026 13:30:08 -0700 (PDT)
Date: Thu, 09 Jul 2026 20:30:07 +0000
In-Reply-To: <87y0fk5uyi.wl-maz@kernel.org> (message from Marc Zyngier on Thu,
 09 Jul 2026 11:16:37 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntjyr36h4g.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 6.6 v2 1/6] arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org, oliver.upton@linux.dev, sashal@kernel.org, 
	gregkh@linuxfoundation.org, mizhang@google.com, catalin.marinas@arm.com, 
	will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, ahmed.genidi@arm.com, 
	leo.yan@arm.com, miguel.luis@oracle.com, dbrazdil@google.com, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Marc,

Marc Zyngier <maz@kernel.org> writes:

> On Wed, 08 Jul 2026 23:51:19 +0100,
> Colton Lewis <coltonlewis@google.com> wrote:

>> From: Marc Zyngier <maz@kernel.org>

>> [ Upstream commit cfc680bb04c54e61faa51a34d8383a0aa25b583f ]

>> ARMv9.5 has infroduced ID_AA64MMFR4_EL1 with a bunch of new features.
>> Add the corresponding layout.

>> This is extracted from the public ARM SysReg_xml_A_profile-2023-09
>> delivery, timestamped d55f5af8e09052abe92a02adf820deea2eaed717.

>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
>> Link: https://lore.kernel.org/r/20240122181344.258974-5-maz@kernel.org
>> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

> Please read Documentation/process/backporting.rst, and in particular
> the section indicating the requirement for your own SoB.

> None of these patches can be merged if this is missing.

That taught me a few tricks. Thanks. And I'll make sure to include my
SoB.

> 	M.

> --
> Jazz isn't dead. It just smells funny.
