Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A16025D1F6
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 15:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740755953; cv=none; b=dWgaVAuAQgBAf1muV4yXlmGQRtbUiYRfhcBNclVsidXbVzE6WUsU+2PPc55lzxL/xFpmitJCoS2SI6FuxMwxlpz7qQ8b3LfmWIgTlluyjamicI2CrDGNDTn1TbfAquPu8aXPILcVphBbpyVMq4E/3wnXEVQ0aBcvEptpHUcX7n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740755953; c=relaxed/simple;
	bh=piWw5v3AaWNogURCLiAS+q/F5j4MCGQiW3lOFbefjZA=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=AvtZkBxkryuRKKowjwSDaAL/g7bAw/ODgsGGOSAQRgwnPhFbzOh6Ccz2mj/FmW8iSL1tAuAG970R78B2TSLztA0Qs96izOIeRXmKaUExBi3QWhYfYOvpvaEyOEBZ/6gIWbvlirEB71tgTkc+m7ibaQbNZCo0uQQP75D8Zc+MCdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cVRIKjBd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cVRIKjBd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740755951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=piWw5v3AaWNogURCLiAS+q/F5j4MCGQiW3lOFbefjZA=;
	b=cVRIKjBdjd9UPD+XTxP7ykQNzRJ0HOUCZIUQDm1oWs6pFM4UQ1VBsWe6/MhFERvaOJ586j
	CEVtnn0nWyKtbJaczrKZXE1bMRP+Ajs5Cwy6NdaVAMvK/Eipum+KnJqeVZWLipZHcmZNp0
	6UKfX0cELoNJGO3ggLPitQiQpY7uaAo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-4aq1ASgnOHqY-d7Smjoy5g-1; Fri, 28 Feb 2025 10:19:09 -0500
X-MC-Unique: 4aq1ASgnOHqY-d7Smjoy5g-1
X-Mimecast-MFC-AGG-ID: 4aq1ASgnOHqY-d7Smjoy5g_1740755949
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4393b6763a3so9710615e9.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 07:19:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740755948; x=1741360748;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=piWw5v3AaWNogURCLiAS+q/F5j4MCGQiW3lOFbefjZA=;
        b=vkQvqOGz3j1U6xWeuLfHejjFbWHzisdX/4/UqV6s+N+m0i6Vx9ospUTTJH7pLWPzPv
         DR8xCCHY0ObpyfcfPJeybkBsrwHDx2hiWZR2FGlN+C1MfrYihjvBkDFhHS5XnqRzi2YV
         hdhPQogLZD2AciTbYzv1VnCqBaXMyewNVw5LHxnuRWxWbrgglZ57A1EBt7tXdj+dr3w1
         25Q4us5xtqdbxTZsJUOOVCy2efGsSsjZ9wWsMh7yQyd7PHoTwAz3EMUSTdvMjRymSvz1
         3tTu5JB+X20N/EOmLutsSWiYbtf2ZTwZac1UY70OTWWFlwHoZNtDaARc/wpVm3pgEqhs
         XYXQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7jcOGTA0UFyUpDTcdIC3mesu/MVKKOQ84vDF77h82QJYmDkczFux/ii1TeQosGDWzUncBoD8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYhD3YxoXZqzascDRAgNtevJ5NIytlDlbCtHlsvdgy8VL7kHcF
	TH4d3b5cNmtp8zE05/bIKdzUzygMIB68yRKXwFmW0u6u6HMx8tCezU3jGhLKUI8x2zf4ILUPMo1
	KuTG+O+gHfEeyqesHcBbB9rsZNtgd8mgGJWg6gc3j5MypC9trTOFUPMkTieDtZw==
X-Gm-Gg: ASbGncu1Aj3DITki8RJOKehyCXcSce1VwfQ3c+QT51D+Xx+pKJacmogzjirzh4fo72E
	qGpjGdcNGZtrVQMdAaAh2nD3hTSMc8H2TptE13kjy2rw2jicxGEf/pZtRS1nsox1A4GAzT6FVjG
	6XlftlgqId+3Ch31Ry9Fz/UBqcCK9Q+RiuduPh4Ir9Mv2Hr5ls6/KbD3EvmRfDs4AFBy2WQeTie
	x0ntz6pKKUz7umLNEFYVK13jEbTm3onWlFr/FHg5Wdo8PJ9qbP+8emorL8Q9AzPLZS1hnUka1eo
	N4d8Uv3EqmnTJVtq5V0MFdKbWzobmdbhjbsomcKZnRizSEmFYOVoSv3Hz/l9fRto
X-Received: by 2002:a05:600c:4f0d:b0:439:9828:c450 with SMTP id 5b1f17b1804b1-43ba67082e6mr34408575e9.15.1740755948414;
        Fri, 28 Feb 2025 07:19:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEVTpPHGtA0mtehU2TvN+X7gr4+lgQoePfplNU1Dml4WC28r5A+HiIriCNJoA58q+KCQMkWgQ==
X-Received: by 2002:a05:600c:4f0d:b0:439:9828:c450 with SMTP id 5b1f17b1804b1-43ba67082e6mr34408195e9.15.1740755948087;
        Fri, 28 Feb 2025 07:19:08 -0800 (PST)
Received: from rh (p200300f6af284000f9ca1328aeaacdd4.dip0.t-ipconnect.de. [2003:f6:af28:4000:f9ca:1328:aeaa:cdd4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43aba52bbb0sm91451245e9.5.2025.02.28.07.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 07:19:07 -0800 (PST)
Date: Fri, 28 Feb 2025 16:19:06 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: writable ID_AA64MMFR0_EL1.TGRAN*_2 ?
Message-ID: <597411b1-ff60-edc3-d6f2-1b21ce2e34e9@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dqNnLR9Hf850ZYKjNkBaVcoBCsC78QH1-2WxzhFcEYc_1740755949
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

Hi,

I'm looking into the possibility of migrating between 2 (Graviton) hosts
and the only ID register diffs that are not yet writable are TGRAN*_2.
Both hosts support the same sizes for S2 but express that differently
(2==supported vs 0=="look at TGRAN*").

One idea would be to either set the guest view for these to NI (for the
"normal" / not nested guest) or allow to convert between the 2 values
(and maybe also allow to write NI for good measure).

What do you think?

Sebastian

