Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AF124886A
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 13:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777640411; cv=none; b=ectrjMuoQ+J3PR+s9Z6De7fZsQhIWcyFf6VDn/MG9W47P0CQdAGGRFSg1JlKzKDBNgWrXI4SVmAHpDos1KWpzZnkVpIzGnlZU6O0AFJXarEeLR0JchWNzCPy8dFjwnt+vwAzD9W3Z9bG6cXEEbMYHPTcaWR9u2LAuTKLCxSG5Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777640411; c=relaxed/simple;
	bh=sLCEaWfAO7nUm59+syKMMoJB8EG0FMX2rc04JgPJ2aM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ExcFBfZX8ObB4t8AjbYFqwo99L2u/Y9yC70epRZm0l7dSR50i7ReoU94H9z4GuVHl+PJpPlybKxXKdKCXWR+gl0KS5/wm9zKzSzDb+Qe8qRjVLDXOU7Vjq7XT12dLOoWocAS5KOF8oNGufHB4/dGQh5tMOiT0eHpioTZJ4aewnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=j3wAtx+Y; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="j3wAtx+Y"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8a3b0242631so25547776d6.3
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 06:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1777640408; x=1778245208; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sLCEaWfAO7nUm59+syKMMoJB8EG0FMX2rc04JgPJ2aM=;
        b=j3wAtx+YFTwOmatx0cFpv+P7ljSUO1J6xfptRJcK++p6KcfAYC3Cq5QSzXwBEz5/r3
         Nwe0u9cR8KiI7SftBDbS+svIsVsOzkdXdP2TtFSmd66BlFWfIvIYgWHH206gas4xXYNY
         5p/Hp9gtZLqAmm/RVpnmRUmJJxvJHOFLxv73rreiaKHUCUqt9IEnBgozAC1xNQQhWGY9
         +V//Ig0PEH+pDzazeVotNR0dslDw5vyoS0P/xNrlUXXc2I3dA6GZkYj5DuvwDYl3iFKP
         ZmseUXro5uLLQLLgSAaaujkFFPCxBWZmBYom75xZO7UoqbZBPa3wdJXyx5L76Q+PVRL7
         f4kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777640408; x=1778245208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sLCEaWfAO7nUm59+syKMMoJB8EG0FMX2rc04JgPJ2aM=;
        b=Wihcp7SrXxLwZX66b2EthPBpX/faC+/g7omZpA77N5533sL1Ic+7tD6c8e7A++BEQm
         4BFP/ZdzeZ0d8zeLFtoCMRK1FKBrGSKn6yLDDgnnaz2RxK9KuHrv5caYBNODJft3xKs4
         uVEZ/aBGUuqGm3+VYwk6eqRm4LQr1cXRxL7noeYyvYTSTtamzrVIw7pDB3JAQuQBHAFT
         hzVUfQEx7EDWo2/KRKwh7K2SggoP+b/hrgSZVdlZGz/k8qNORhYLdmUSxgtESxopGEaD
         SJ1DRpSgc2MEiN9npLhrDaBSB/CTGi1q5MYV/hGoBX5TS7grcLUJxJmWLHP+psGOPb2e
         egAQ==
X-Forwarded-Encrypted: i=1; AFNElJ/dU2beZouDWlkhc25xIWGc01HsW7LL/aZ/Op54RFJyyQD6+8R102WREd2yQiml2sX15m03Cmg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHfuD5n5ZHwd5xn/B5eT0b33D9RBQq1tbnUA3uKUDcGsPtvVEk
	r3egyY0fdfiMrDuK4djDO/CxXfD5692BMYwen3zeFWxLrW7rciTFptz9TWsD1XFVHPk=
X-Gm-Gg: AeBDieuDcUT81d/clRpLUhZ20DXI6Ax23rOv1ptjIXVFxxvSJ1MdnskYiSJAR+YVtob
	f4AbEXMsURAW1urT0ywMeJUDcXHjt9+MVmNVn+hSuE80PO0nda28XN/j9aom7sAINI7Y/LmQDXo
	gnA4Hsy9kSjSPl/Z6fxbVNCcOnIokukg0HzzrtEbYIZR1gsl/M2CdMo5DPmm5+hHw8ry5nQNAMt
	11UsiwVjg3zLKUtTc0ij+V6tNtqJ+a4c3kkVZ/ye+KoOnkxkKkWUF2T+WZmyvnvlp4T5dXXWwoK
	FcDzijYoL1vnGun4katEx+TDjoXLuGNs6aknHIp2vgxDymwGb+zHa8g8jIh96G4lH+7XgalCBfa
	OfVfY2A6rs+36bAmqjTkrGr+6Pf1QiAsxW6wjF5UeXqFXDYE6ZdjL/g4HS8E+Y2cpOQ14sOieJ1
	yezVbr2zvcSEWPO4yXDvhzto4mYTZ5m6tnvSxcuQp457bAwdda2gmvFdARhhedX886m6H8MSpLn
	thn0banIecyPo1j6+xHHTY/Ng0=
X-Received: by 2002:a05:6214:3d85:b0:8b5:e126:e77d with SMTP id 6a1803df08f44-8b5e126e7b5mr18314046d6.8.1777640407970;
        Fri, 01 May 2026 06:00:07 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b53c7accddsm23110796d6.36.2026.05.01.06.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 06:00:07 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wInTS-00000005DWr-2vHb;
	Fri, 01 May 2026 10:00:06 -0300
Date: Fri, 1 May 2026 10:00:06 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 08/25] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <20260501130006.GF6912@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-9-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501111928.259252-9-smostafa@google.com>

On Fri, May 01, 2026 at 11:19:10AM +0000, Mostafa Saleh wrote:
> Create a page-table for the IOMMU that shadows the host CPU stage-2
> to establish DMA isolation.

Is there a reason you can't just use the CPU S2 for the iommu?

ie the CCA RMM is doing that, it is how ARM imagined this stuff would
work.

Once you start supporting DMA like this you have no choice but to keep
a fully populated at all times S2 around, why not use that for the CPU
too to avoid faults?

I guess there is a reason, but maybe explain in the commit message?

It sure would be simpler, you wouldn't have to mess with iopgtable at
all...

Jason
