Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D470C1BA26F
	for <kvmarm@lists.linux.dev>; Mon,  9 Sep 2024 13:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725890149; cv=none; b=ilLxw6clNiqGR4JeVEeg/5nDGpe68WTPsPVlWGhRXsnPMBO48ntQoYvPnhUekPwN6eawgcmKoZxRbUOxZLwRUdQEeXPyad2nmVblLaA6CwBhRm4NKkKBurWl6bfsnYQqN10FwukBGGpjrYlwxHEH6DfgSqmIh/3l0kza1IvywVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725890149; c=relaxed/simple;
	bh=DBSqSKKZCT86Ns+OwHm8+kGgzIhmdP3PE7fnwZ2cnSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=JRrxULu/NICHPMOTFVmPLi8G5HM2PeY39LT38RebgdFvSZPh1W3tCwiRtS0XgO5L0O+vqR8SXlYSOzHBoH5tckb9E7NDHSztKIlz1SvxghHW/ZGmYQowDvKOAH9b8WJ6LleIYJIqWkYvpdo/yrJJMI3NvNxWWHcyUi925LC+yps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UpmeDKDD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UpmeDKDD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725890146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=phI90hKtthNRNf98RPRiQsc1bPNjYM/u78Q8gnoGCn8=;
	b=UpmeDKDDlprjtQyy1a1fYdvIWuW7FEbNlwGrcs11Dn7BGfybkfnJn31Q25Ltl+i4JBKYDm
	x2etvEh/QyfpjQB74KEF5P5Z/ulguUVs4yuHYn2SHcDebYbpd7Y7UOm9rVpRE5+kBBciik
	PAe+fUpVPiDY+v++BI03MwV+iXuX1w4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-6sL1z0pMNZ-kjeB58AHDEA-1; Mon, 09 Sep 2024 09:55:45 -0400
X-MC-Unique: 6sL1z0pMNZ-kjeB58AHDEA-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6c360967e53so54945606d6.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Sep 2024 06:55:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725890145; x=1726494945;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=phI90hKtthNRNf98RPRiQsc1bPNjYM/u78Q8gnoGCn8=;
        b=FCmb0OOc0tYaZwfQtdz1MaQsX3NuHKTdBXbz7JQqYPFsSUbNern1ju17M9p+2hhwtU
         s97sfhD7U2fcfjpoGMHiMyYkbD+O1ELBc3znYKfjyCmOVvWDqpRHNzE2UsmHSdc5noeN
         J8jZi8KKWKlWgWJuLoujIAuDv1WauJAijByQJ6Z6W0beWbguMNwIZ4p7KwzIt2Lk2rJN
         phc1Q6vKXOx3Rx40ua3J8T2M6P3T6YfUQerW+HUaut8e7LunYq7SoCoEsYb7iv2iNzhw
         B+/WhNhxMU6iq33/5vhi1VFHlkpv9Qb47ZQpsx+Y4c+nQ4lZ3OLoMjWFHfko+GogGDrQ
         RzFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBFEr8oS+obdE5e7mgycSapPMklSd18ZyBi+UXNszlL/IZSAp6QL+GTbkl7gwIvt497bA635Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywx0SCDua5/xdh6LJkXRSMHzwZwxri145jQAK4qyw6PD4CdXXBX
	iomTHBVONRENSn64LTRSNtRtTwQebZJ6h1rMrC1FsuJHdpSeXONaJng/7WkikbiIObD+HTcu2Ok
	hIqlBAD2qWxx1P1k0ICKMno6KHL8J3vaCmzLptLVTYHMl1/K4qLC3Mw==
X-Received: by 2002:a05:6214:1843:b0:6c5:2a13:b8e1 with SMTP id 6a1803df08f44-6c52a13b9c5mr96954276d6.43.1725890145002;
        Mon, 09 Sep 2024 06:55:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQcseXYtQRpNWe4UC31AKTYj4V8OS7K7G0X+aaWgh8qtUW96w7rIdRupRfllbFa2yALO/OQg==
X-Received: by 2002:a05:6214:1843:b0:6c5:2a13:b8e1 with SMTP id 6a1803df08f44-6c52a13b9c5mr96954066d6.43.1725890144589;
        Mon, 09 Sep 2024 06:55:44 -0700 (PDT)
Received: from fedora (193-248-58-176.ftth.fr.orangecustomers.net. [193.248.58.176])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c553803dd6sm940686d6.14.2024.09.09.06.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 06:55:44 -0700 (PDT)
Date: Mon, 9 Sep 2024 15:55:39 +0200
From: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v5 12/19] efi: arm64: Map Device with Prot Shared
Message-ID: <Zt7+W56+dKhQl7GG@fedora>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-13-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240819131924.372366-13-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 19, 2024 at 02:19:17PM +0100, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Device mappings need to be emualted by the VMM so must be mapped shared
> with the host.
> 
Typo. s/emualted/emulated 

Matias

