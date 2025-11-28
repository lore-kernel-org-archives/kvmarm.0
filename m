Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547EA285CA7
	for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 16:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764348499; cv=none; b=UCY+YzCsj2fd8Fdk13/gqsZVxLT9I2PsO7m7ACPMZ77+cl9VW+/bZifQvdeuqPnF7SfCKNHQdJSEqt4uyWl07d+jEzOPZI7hyuckOvmmy5AyDiX2grh5gMwzEieQ8xGo7PSmkXP97IRFc9H2+2SJGXL7IF0P1oXHBu57/yEgXFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764348499; c=relaxed/simple;
	bh=pK8K7Pa7QZb6H438w2S79hy/rHjho1lVUg5bIpSNGXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OV1DNX+81ZQt9FYXqFs/0W0FJTmfvoXH8bRucDZbhfQrdprPIopPv7GSBQSifdyGIsIdZCiqlfcw7kxOOJi96ZfMnugn/wOf3/1q6brCQlvDjyJQod/hePJuqQ95n/TraHNO2Dvc+Y3jR+ePtO8eT+TCL6B8nFvT34gAYsmh2TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=BJJ0ze+v; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="BJJ0ze+v"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b2ea5a44a9so176607385a.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 08:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1764348497; x=1764953297; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BAfMjKf1n0EM57yS6vP5/PFm4GU7RlouzaAGnKGJjA4=;
        b=BJJ0ze+vkAIhtepzgnldPEeitmuGcBzX3AuwYFf+8SlcbfD+OqJe1aJulVgkA7kZXT
         SgpdJWCZWuaZwYe21bt52IfPwlSTtFITsNVIzhz4sZLHS3uE5wD6I2z0DQHbU8Aerchd
         X1JvtOoiiXVm35at40Q9UnVBPct+aIT+I5VrMfR9Oy5KUpEf4G5NAg9zjePhkq/9Pq+X
         bCA8CpYko3FU0RhBvZDxXMPw4A+PJYVOeYcyH5MIpvxbRtJfQcAB9FWRJ5ziFYj3spXK
         BnC7H61QVBOzWi1TPkQHXyvJE0pDxEs5blQUhkWtC88eCg4SsxasRdweuYA/exGnmXIP
         6jvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764348497; x=1764953297;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BAfMjKf1n0EM57yS6vP5/PFm4GU7RlouzaAGnKGJjA4=;
        b=fRu5Xg2/+FjGaEd63q1yBvFWezg0f5Hv4X/8DmUIZwck3+gaQ5Gp1cRwgA8ZHZ0HFA
         wBRAFRSkpnabL175tsNHjc6aJZqioiiCBdRLuYI8u2uaQcY3B2RlxM2ukO6B7ExYQesj
         yCQAJIFry2cevjAwzjtbI8AWYTDwlAb7USfrU/am6bwLu98Xs6QBk9YC/cANns4jey98
         to7k90PWJpYym89m8tAo7B+3eDqJZW9Ye+1Ldr14myHelDRJtcJa0059AMpcrZo+p8Qv
         mgOyQxC5iiMepcS0/arOI3MZ3oF2E1NiJIRfEJmFBig+g142HmXiStzTDCmyXayS6pvy
         1YGA==
X-Forwarded-Encrypted: i=1; AJvYcCXieIZL8QlZ76R+StYmYPE/dCVf4q37GwbQCcK98+HBvBeoUjy7BcJch88/zOI0wTjcg/FbfMI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwFE1TAIJMmt9InYPn/BspLe77CSd3om2UCo9+oSrNBq8a6bvTt
	rfdXW/7T5uOqMrLHrNko6pkEvq4fcb/KzjrtPDRbklFE4QE38/2opIsK4dYKaxT2Gjc=
X-Gm-Gg: ASbGncvwd/md7mUaPrEj84lM4wS1dOABjqsrLB5sDu/JdF7lCtNc675joTOaQCUcg7w
	9MP2VNsudHYE+Tc02EQ+db5N4EZ8XuBIitxEo4BUmBNEjBPs/n/M9axL+Kez1sjMYVrfQVfr7IG
	ZoUrJv+6QaNEc8Tc5UNDg+VxJ3UI/+QHN8u4MlVFMbDBb0xysLfDkkk8vEm/CrOZIKH6Cum4rGS
	aZW/uxAL2FaWo8J1vsNoqWSMER85usOLZ5HkjchAXYNOtWc3NBjUkFTELaNUbRYmj7dJT0C8o9M
	hP3N7MyUSvdP36l5MdApACdKidGfHQqYFmn0FvrEZEX5IMlo0ERBso7ic/hHM/30xpFv4I5FfnR
	JOKuP2vaRT/Xx2ic+1lHCOcsoHcCR/TydT0AvJRxVuDkNzcmBiMa2iask8LZuWK0y4d6iogcLBb
	QvJTnUh8U47x0KC0CTbSbHGNyVXZVoyv7L1F4Qn3Hnp1zgKP3c9TfPz7OJ
X-Google-Smtp-Source: AGHT+IHQqaabicTwzKD3aV8B7vGpE1WoUx4p1TCHTluWfNaKtOTmIupEbWyDAmYJQk3capA2QEx8FQ==
X-Received: by 2002:a05:620a:4496:b0:8b2:76c6:a7ae with SMTP id af79cd13be357-8b4ebdb0ab9mr2073856685a.50.1764348497176;
        Fri, 28 Nov 2025 08:48:17 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b5299a5f1dsm335208785a.13.2025.11.28.08.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 08:48:16 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vP1do-00000003PwW-0xng;
	Fri, 28 Nov 2025 12:48:16 -0400
Date: Fri, 28 Nov 2025 12:48:16 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com
Subject: Re: [PATCH v5 07/27] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <20251128164816.GC812105@ziepe.ca>
References: <20251117184815.1027271-1-smostafa@google.com>
 <20251117184815.1027271-8-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117184815.1027271-8-smostafa@google.com>

On Mon, Nov 17, 2025 at 06:47:54PM +0000, Mostafa Saleh wrote:
> Move parsing of IDRs to functions so that it can be re-used
> from the hypervisor.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 112 +++-----------------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 111 +++++++++++++++++++
>  2 files changed, 126 insertions(+), 97 deletions(-)

I don't see that this slow path stuff needs to be inlined?

+10 to my prior remark to not dump all the huge inlines in the main
header.

Jason
