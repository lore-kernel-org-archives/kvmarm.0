Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577633D0905
	for <kvmarm@lists.linux.dev>; Sat,  9 May 2026 23:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778369375; cv=none; b=SH8dsTQ4bCJ0HwndhRzy4OhcfXQ09oxsUqQznvrvmEEhqA8qx/pOjyOne/FI+wNzegeyh5OsmbVzCxTIJcc7TkfHRyctNMlgNnvJM8PmJUNkIJSmWy6sB2tUvSSirNwzmYdsPOg/bEyMtP4jNlzVv2/pF+bCOYUjs++5/UrrkCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778369375; c=relaxed/simple;
	bh=sce070X88mUVBdz9b9Y4+DDwl2h8zEkLOKh5Apexnnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ngpA3NDaeuV3gcpD6PL8GB6i7cZd61ZT04iaAMHmDINmlio53XORwDlKcpM8kg5DrD1aEVMMxyUs/6q3n+fmWoR2j2SS1WqtcvaaGp25+czYrdPF+Mag4a5/ueoRHI29qY8Qv231tEGdwlG8hgCHJC1N0P1vQBQ5+szPnYVSo5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=TKS03tp3; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="TKS03tp3"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8b81586dff3so36172556d6.1
        for <kvmarm@lists.linux.dev>; Sat, 09 May 2026 16:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1778369373; x=1778974173; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sce070X88mUVBdz9b9Y4+DDwl2h8zEkLOKh5Apexnnk=;
        b=TKS03tp3PaIHG0roBKMv0YUFMmjXGUm6hR/LVK1tEW85eFnpgc6eRl7RoJ8CT4BFW3
         BwKofKWHYEF1x5rnc2/74p1g7K+ke5vr0PDqTkz23rnuLbbst8BF6CkZ1Qnof4UmqJ3/
         ZnbeuD4KgKOjImzpKO1OrzqDB7GlCgyxhJQl1ZyK3u3Vg53M5s3WvvXVt67nFjp3dXKS
         6Vf7MimECp/CJxOCSzclKKYKM9ylAiijk0OpSPO7i44fgSFBjuYDBYRscJoRqyV0yJkf
         qNWaywXuCuzo6SWl71loa8uEFi8TWtsVcLXmLoFI+a6qnxp7N1ZiQb48s9YX3l1CbobC
         erWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778369373; x=1778974173;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sce070X88mUVBdz9b9Y4+DDwl2h8zEkLOKh5Apexnnk=;
        b=my3PE22V3Sn/PJwXTyI0v/fM5GrqkLIOle162WWBgJrzGJukZOgGnb20m4mkdrbZVX
         YhsszytIQIs7I8S6CF5BTFz4Lzx5728kWxoTiiYR4vgyO/3P2HSoXHfTQf0LH7PEJNJt
         xlSeKP4KAdKJz/Xuu0av2OX54D+IQBvoJVuaTmOgodX4VE563hDRi8ntOJ4S/9JKtHK3
         NzHSOWBytFTeKk7aJVwHycXycfNpB5A8j9D/W9YVfCK2wEhvM09OxApXFd0BAFrDjDN1
         qmiuvIM1cAek6f+Eov+nSUycHFR/9BC/w8KtTPk4J3d8l5/0h9VLgSk5VlJQohHZavrN
         5yPA==
X-Forwarded-Encrypted: i=1; AFNElJ+9V83uXCtndxGfTKDFbBxUzn2F8k9Fv7WO6u1SV5GZZphQnqlDRvT2ylGicprERXxoreg+SXw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxzcg+HYzcwf31E0hOXAzZnhxYx6wkimVC7c+Wnjka4CDgBGkUn
	km+SxZ+8v2pCBwgs5BN8CI05TfIHcq0bpaXOD2jQ0MGsYBnYvemLp+zgBmVlxNHDAtE=
X-Gm-Gg: Acq92OEsqAXEx1ET7PpEpSHmgQXW0zFtZOgV+pWa87j4rnHFYPkmkRjxIP3yFkz/x44
	PM1iMeEc1GbMbxpdFVCE6CwqSC+Nq0VoUlWdIXjXMrx4rsKOy8sSVCk8YlTNG2MDu+Tb9lnXZOL
	vEWrzV9iqEEkPm0eS+a8nd1uQVy1JZGnn1sS+Kf+REKFsS4nCOWXmu7nTt2VvIWBPzsBbwV/Hn1
	kUhEy/7Bd/3HU4tfTaynakgNNf39zupYJV+ByM08v70102JdhiDXGFm4j7r54wETg+SBx6h7zqk
	Fd8Yj7Dg8uUEqxctnMnGJOgwLIktp+rBKbHIaQK2eulk160EB3+Uj/OqOdFCuomAmRSeM4rQ8LZ
	ADOql2JxUc9/r15uAhh8GZsq0QFTdlv/zvrtp0e1vMJ2aM3siAk4kFpUXJV1j+k2dKJSFEBqyWI
	gyQ5hopVaCZPkWxKkd1SXJqun3U8vW2wnPs636cRRzGQXGlGUmfJYmJ5jHXwdAGdtrVAxxDX63c
	yx/pg==
X-Received: by 2002:a05:6214:3a8a:b0:8bd:de6d:c33a with SMTP id 6a1803df08f44-8bdde6dc799mr202539986d6.21.1778369372915;
        Sat, 09 May 2026 16:29:32 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8bf3a33fab4sm53837756d6.23.2026.05.09.16.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2026 16:29:32 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wLr6x-00000002NrB-31tQ;
	Sat, 09 May 2026 20:29:31 -0300
Date: Sat, 9 May 2026 20:29:31 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 04/25] iommu/arm-smmu-v3: Move TLB range invalidation
 into common code
Message-ID: <20260509232931.GJ9285@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-5-smostafa@google.com>
 <20260501124143.GB6912@ziepe.ca>
 <afiN1UwS9q6F6A_v@google.com>
 <afoYBYIJOTClsdLS@ziepe.ca>
 <afoeIVIGE-JjYy22@google.com>
 <afsPfEzgGtAFrN5P@ziepe.ca>
 <afxd8Km40A5ulZvd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afxd8Km40A5ulZvd@google.com>

On Thu, May 07, 2026 at 09:40:00AM +0000, Mostafa Saleh wrote:
> But that doesn’t solve the problem, which is: At some point, whether
> eagerly from the page table code, through gather sync or a fancy
> invalidation array, the driver will need to populate a range
> invalidation command (tg, ttl, scale...) and this logic is better
> shared with the main driver which is this patch does.

My point is this patch doesn't share enough. If you do need to issue
invalidations then share everything below the top level tlbi entry
point and don't try to make a pkvm version of the entire logic just by
ripping out the range logic.

There is no reason for pkvm to need a different algorithm
here. Especially when you get to supporting ATS and multiple devices
and smmus you may as well just use the whole thing.

Which is why I suggested to copy the entire call chain into a shared
file

Jason
