Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E713E2D46B3
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 12:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778849947; cv=none; b=FqJNi2jSvwzKYF4Y9MI3o8APWqwZcL4LX1wWL9IVpDahX4j2l8bWkWI2aOPqiX90nrqMYx4jLdAJq70lNMisfH2xQVmwNudg05XNH+Vs+vVwueyuhJqmjXK65fx+xfDPBOlu5blpm1G+ijKup6JhOn/V80QanaizIcOZLjggnoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778849947; c=relaxed/simple;
	bh=MO6b2/mkjbhSBCu3D2Z+3r0LFP8RdhbnC7Bgq1HXVoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EUWgOF1kaBkUmhOUL2PWbxg6FtVNMku3X1FeGYetlqeS9hvu+bw/7O1jMlUhhMQRxIGqVH26fYITfUyx0hIN7QpR4zP/tK9Py9aicM+DHlKVDu7vQghUfkwghlq2Llvjf8QbiAlcRj6iyp1eSvug1oUepDRFvkeZhFDgYLgLgy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gQl/1Kmi; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gQl/1Kmi"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-44c350a5b87so5627815f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 05:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778849944; x=1779454744; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=skcHqYBlrM1emWOE4306eVJFUzXeydUKGsGl+9rnsaI=;
        b=gQl/1KmigeC38TZwesxHwZgAQsGen4bftA2BdfOOrpfhF46vuGULR3XfDRcyRB5iXT
         NmoTTrl+rDqJJsJFICQaC74zrdp5AOXGwoKnfsQgzhRf2vdr+5qL6/VNwRO670zFc+YM
         C+p6iYXAYKp3zqTTTBVjBBuGs4TUmYISpvZipjodIR9q7YOeD69DoUjDO5l1z1ogSgNL
         vyXZY0rdSb86P7doKKeN0AeVjW13qCFxUGD/tJPDHNJq8jXKrxrwGflNg6tIrubpL3cO
         N7lhEtnoXpyWZcdcp5yCTPR6gzX1kNaSHN20Lv5LfmkAzJh7soDaEpAtoMcTDxhWGuRL
         7Y/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778849944; x=1779454744;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=skcHqYBlrM1emWOE4306eVJFUzXeydUKGsGl+9rnsaI=;
        b=Ka/vExD5tHP2WHy2ociuD/Wa0b/y3vNKzbrVhPH+GZzfg3CZ6dMS0R4CHH+qZUg6Tz
         6yB6N1kD4+YOkHz5Vm5FcjxJSOQdbmjcfsf+oYtHzCkOewKhyiV6wsN3SirStOnbw3OZ
         GC9+8upHS37l7qHsue+XZPDj11DWu618EBeHk90OKb3oMcYJTOUC91DWHqLS+igDjwlX
         GYgtLhREQ3SsIHcCEXQUrQLFo5sawObyNQmm2PmFFib4PWiuP7diLAXtTdc0PLTDY8lF
         2DOyqbfFLRY5ALaf5erIYyFCZfuYlKpLk335U4l9Q+956Gh9ITegJ7PrDLkIuSEcfGxR
         5tRg==
X-Forwarded-Encrypted: i=1; AFNElJ9x1+U2kzDNRxFU+ljcQqWNEREB4UBUMBLMVScRFQaEvXEPvWQpdyvLDum03Gdc92wmKELPWTY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzA6VSm+n3SICMtnBOCK/FTnpS416Dhj+5GnuPq2Nkx8sD3gg0O
	wNVl+0B/2mK1BenwWCY5xXrbLp9Y1FV1KSvP5kTN+0wozfXI2bgifN/g1TkPTZLehA==
X-Gm-Gg: Acq92OEXuriIe7d0Dym7qpUjLsbrO7rDWwvUtfOsdEOR+fReAqJ8WnmjFRUsVOBeqHr
	3eshgysl9E39ImG9iED2GTDfxBhx8CnbAvIAxlXu8dFVm9RiwJC5Yee1GWrm5wG8QsWW02wbB06
	0ctYSprgV6rN+47qlSwhfgUdse5j2Ca3dxihBCW43Gsy2MHQ+6jDN4Sic5Vi6NhKrkO7A0PWqCy
	UJC1hsAyVY/tHbn7c9lxNcMl5/TuDpEryHN02qu1aXbwPUrU4a9T5KqY/Gx0Q1HwlEI3kMQjQOU
	UID2cdMKTUvGi1jg69426JEzK5L+uyhTb1ZW00i5VyV6QxvMgqWGd5EzcsBTdKBfdvFcwDuBhAN
	50V4QtaeS2E0cT86sd5fs2SYkcBYfct+xOwi+oqwev+fFqMJ3/lCkvSS5HUpCNQv1xQv7wS3iu7
	ioFKTtOlGz9XQgz4IXlIf4Cx83HIlepNdioEkuId1yJg8Ccd1L6HRHoqzVHNHhBIb2iQsw6q4R8
	7TvJg==
X-Received: by 2002:a5d:5d13:0:b0:43d:7a97:78a2 with SMTP id ffacd0b85a97d-45e5c5e3384mr5357411f8f.28.1778849943799;
        Fri, 15 May 2026 05:59:03 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e767ee0sm13812111f8f.1.2026.05.15.05.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 05:59:02 -0700 (PDT)
Date: Fri, 15 May 2026 13:58:58 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Fix nVHE/pKVM hyp tracing error on invalid
 desc
Message-ID: <agcYkufvLE-siBum@google.com>
References: <20260514162624.3477857-1-vdonnefort@google.com>
 <867bp5x9b8.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867bp5x9b8.wl-maz@kernel.org>

On Fri, May 15, 2026 at 11:21:15AM +0100, Marc Zyngier wrote:
> On Thu, 14 May 2026 17:26:24 +0100,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > pKVM must validate the host-provided tracing buffer descriptor.
> > However, if an error is found, the hypervisor would just return 0 to the
> > host. Fix the return value on validation failure.
> > 
> > While at it, rename the function to hyp_trace_desc_is_valid() and skip
> > validation for the nVHE mode as we trust host-provided data in that
> > case.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> Fixes: tag? Should it be considered as a Cc: to stable?
> 
> 	M.

Fixes: 680a04c333fa ("KVM: arm64: Add tracing capability for the nVHE/pKVM hyp")

It is only from 7.1 so no stable to fix.

> 
> -- 
> Without deviation from the norm, progress is not possible.
