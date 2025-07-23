Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C471F7910
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 15:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753285210; cv=none; b=IVRTOBy4WvWbjUoSj79mKumCg3d05EAAGTgdJAXveUVe6x/R9fKQT+DyHiNZ4RjOPY3Lp9R7oaIiZiqgGTrlsgxdgvQDqrh3t7nKNouTo+58siK20BfUA7qphipN6j9scyV/Bwex2GiLa1UK/BgwWK3vhysy8Xx+8DopI+ndmto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753285210; c=relaxed/simple;
	bh=BbnjsD8D8fd/oPMol8b7h4DNOpO8k+r3dNGd6webbIw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=X3gR38RDJNj33m80qgk+mMFERcxP4S9BcLtPN0lspPna2Ge/oganNAts0YZfKEwaWii5Y390D76rZkctau4D7PDhWog4thKnhbjis14vlubF/e/HuBmtj/mwf/l82Uzkb3a8BtmX74d++vTOJ0T1Ljw0tx+0am90bRDjJrx4OFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X33EK5DF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X33EK5DF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753285207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BbnjsD8D8fd/oPMol8b7h4DNOpO8k+r3dNGd6webbIw=;
	b=X33EK5DFbHQWUYLzTgiourtxi66wtqfJdyItbgcsqu7a6SjgNta4oY8eO4yCB/bud40eEN
	vh/0MD5ZshYjsjPe1/cGfapSfTVp265pMmnel2lG9Ka1VYAHsb6hKAsuvmsHv93UFJNkPY
	t9K4mCLZjzFNVhFXFd36Chymclapo0A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-gOgFzzHFOY6fcsUMhsfAMg-1; Wed, 23 Jul 2025 11:40:06 -0400
X-MC-Unique: gOgFzzHFOY6fcsUMhsfAMg-1
X-Mimecast-MFC-AGG-ID: gOgFzzHFOY6fcsUMhsfAMg_1753285205
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4ff581df3so31242f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 08:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753285205; x=1753890005;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BbnjsD8D8fd/oPMol8b7h4DNOpO8k+r3dNGd6webbIw=;
        b=ZO9mWETU5weepDiFJjwEVZh1pd9CMDtXI+cdVntN5Dxf3kJ4y/yphUV4lZGZkOv36r
         oh/MRsUE+AgixyX8V2qKA6wKdDaaCmrzh+/8nwW7CAdrXAJ771FQ+F3yK2WSyoj4Blkt
         3pcbDshnAYWzh1gcKDgyvWlDeyf365Q9pNK8QymGsp8aiPeieTFRAdotk1hYQPP0EFD5
         xtEKuoRzgzLeOhdLsjd/oKpkhv8/VnGZs9eU1TdJNVPDtMH16a/Nvzw/mPf8pcVSknLu
         lceV9WUJ7t7nKar7GsGJstBynAM+F+tR03g5pj58q0AtfBPdZowQ6ROzG5YjEjO2z5Q1
         6EhQ==
X-Gm-Message-State: AOJu0YzE8xEhy7DeFgYGfFdg3Srr8CuHymDsaYq7n6XoDm8GWfh7tKmX
	EMDePAiiC4Y0IHr/BQxRlKBeVbA1uyKsxJCZSa2w5zAhdKTI6NBUugui8efc5781ANynoUrwsxQ
	c8AZZe/pHCLA2zEfD2xnpd2WOeDcenVaLhqZHuSNdxFViv6mHEy5CgLVSPZRy5rClIQ==
X-Gm-Gg: ASbGncvpwESjeYJtS62HD1MnjMgm9An8LUI8+TBfyJMIHSsrVFptexpATf422HWvcUE
	IQsweujL6m9JD2u6EnMT2lGGDjQT94m74ZwUiVwNaTKPDlsYrg/jmG5VtzrVbXosbZmXl/Fy29d
	1xUlt4jM5c9fIDpxlsc3AfmWXbZBnHSsHMRBDtNDeL8LesYFaBX1sjgIhyckl0qXxfzb3FSLRF6
	4w5gvfIk1uVOj+kjl7sy0LbNNEwN9VJpkFkOU2LwZpnOrXv/JzbnbiiG9Kc0/7WE7ERWOW9JPxp
	Aj5wzjdshlF030Bof+rL/ihdcKgZ7FIJq3+ojkjDkz1/I56TCUErbOpI4PDOAEhCYa0v2q7+u2o
	sDBL48B2kI/Px
X-Received: by 2002:a05:6000:2403:b0:3a4:f722:a46b with SMTP id ffacd0b85a97d-3b7634e592cmr5632738f8f.15.1753285204888;
        Wed, 23 Jul 2025 08:40:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsc98BzmsjHqrVG2AWlzqEG9l1z4Dg4Bl7UILlo445wKwDwA6rd8BWhQgGwVIisFVWO4wVpA==
X-Received: by 2002:a05:6000:2403:b0:3a4:f722:a46b with SMTP id ffacd0b85a97d-3b7634e592cmr5632711f8f.15.1753285204420;
        Wed, 23 Jul 2025 08:40:04 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5c5e3sm16917670f8f.78.2025.07.23.08.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 08:40:04 -0700 (PDT)
Date: Wed, 23 Jul 2025 17:40:02 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
    kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
    Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 3/4] KVM: arm64: Enforce the sorting of the GICv3 system
 register table
In-Reply-To: <20250718111154.104029-4-maz@kernel.org>
Message-ID: <601c0048-ef37-0695-8c46-e703884b3612@redhat.com>
References: <20250718111154.104029-1-maz@kernel.org> <20250718111154.104029-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D1tnZLc6iE8cK7RAAfPz9FXtsu9MCHhZOtN0dzI1-KI_1753285205
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 18 Jul 2025, Marc Zyngier wrote:

> In order to avoid further embarassing bugs, enforce that the GICv3
> sysreg table is actually sorted, just like all the other tables.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

