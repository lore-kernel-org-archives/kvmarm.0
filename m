Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF4325A2C2
	for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 16:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739548977; cv=none; b=sO6D0tRxqWuuWIx5ziWDe2vvAwpoJpa2C806QeNnXLX1cR3Y+kgfHcck6HadAUxdqWijGG4+vS8wrHgehAkEWKueQP843KgxDR1BFWbaeZls0CI51kebS8xFFOd/uJAstEGqjTou0gu3aTjW4aIEkufhoPTz5Duh9KYkk2BbnUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739548977; c=relaxed/simple;
	bh=/gjO6iVz9lr+34ZeU5HqvDEiu2duBsxipVqf3SL/CBM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=W/uevr2iJ04EZVk1ArA5341J/yNGiHoM8GVSyIoX+KpRIidbV1bYk9Sd++cQ9kFrMxuarLbIH99mMFIIX+2JlUsbg9YP44jVHb58RqehL8fwQAPMYd+yQ5LswiBIXf7OEnAFpSw3Io0869RAFaFYkqXGsSUSef7TxUT6ZqjV8sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bp5OOOK8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bp5OOOK8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739548975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ov/yz6TvqZ9BKjuI2h4Bh45EdpqAuSzrPazgzJB47HM=;
	b=Bp5OOOK8+P7qmmquKqUn7QaRHZzr6AvdCaFNtDto8+271rr+vmUNQbvsOdtVJMwpr98oEe
	5BhSau67DMPI6p7WIjG30Ln6j1a3nh8yqGhQkQr3d0kxVlENlA9zZwagnUq3jBgT+EXKFP
	FoEiWHGr0Klpripl0ANKxi1rX8n4QJ8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-anQosVsePIaBgUGYjQj1OA-1; Fri, 14 Feb 2025 11:02:53 -0500
X-MC-Unique: anQosVsePIaBgUGYjQj1OA-1
X-Mimecast-MFC-AGG-ID: anQosVsePIaBgUGYjQj1OA_1739548972
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43933bdcce0so17775645e9.2
        for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 08:02:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739548972; x=1740153772;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GHHGr6UlqvjFzr1C6/ImYP9v1pPBAQVBHm5GV6R4VUY=;
        b=qgFSb/eo39j6cBJFCzBPEcsVjZkOOorDMK8ycB35/8nQVWUyO/uRigmq7I5tA3Jjni
         77vA8C42/hdn9x7+NBVLmLrMb6Ota+dzqejY4tFHygS8IL7qlnWWeenoHMTEwHEM7leR
         wt+KS6IC7EVJO8677xI6REmunTWaIQ70oKs57pk5AfG0N/F+nea9Iq/Yz2dJq9VCK+a8
         X4Ouc601COeEa2WdhusN5R96hg9NdiyNFuFPiYwVdEkvZ99Cfb3yPcOny4jaunOSximo
         VOJvBliJ5A6fJor8x5InJCKpesZn0NurKEDGY0hkW9FIAGa3D9fKS4QaPphJLN+E6dRn
         lCcA==
X-Gm-Message-State: AOJu0YwE5iMzBRh+A2z1SLlc77CKnHDD8702DEjtk47h38TtuJDwi5Zh
	mBRb047uylq5VGhzcXou9QYj4U7bNgStxYiw+3cIRp5p9yhscrUx9F8XOH6DX6cykKqNABnGpfo
	11d6AyHBYgs98W1PVAHJsmDFhvGXKBAJsNehU9O6tZ62l1+IhKU9eUw==
X-Gm-Gg: ASbGnctQIi48UWHBSMnY+PQ+u5G6G4XNPMBuhi+Wed8wXXX+NrkqybvzsqCA9K8TChx
	hVzS0gNOidN+7I88WujqgpUiUY9rx8KO7BDN7P5PaouyebHGhe3wRt+Mu5E8L81G+5+t012VGI9
	87AXgP6GecWwxmWu+ZAnmXKg6YyAxND8pCqxdmBUplPJ2v/ylFIpLLymmODwSrnwSjTuOJ25Cy0
	NnHQXqXoMcWfjkrbsFpNrXtzjWKUVLurVuFxBczHj0fXPnuHLhxqzsc9WXmqHhUGKU/eYGj5fU3
	Y0H0d139x2eL0DDn8kBli41XHYn9KhYVkSCxhi4rxqVM6bVXrTmX+A==
X-Received: by 2002:a05:600c:3b0c:b0:439:34dd:c3cc with SMTP id 5b1f17b1804b1-439581b278amr139019815e9.22.1739548972107;
        Fri, 14 Feb 2025 08:02:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCWi5zgJmLNi4VvF0bp4+O6Kdu/1ZG0Ttr0yyud1Bsg/IXKfIJhDyOIe3BpTuYO9E29gTAPA==
X-Received: by 2002:a05:600c:3b0c:b0:439:34dd:c3cc with SMTP id 5b1f17b1804b1-439581b278amr139019075e9.22.1739548971663;
        Fri, 14 Feb 2025 08:02:51 -0800 (PST)
Received: from rh (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4396713feccsm23745125e9.39.2025.02.14.08.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 08:02:51 -0800 (PST)
Date: Fri, 14 Feb 2025 17:02:49 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
    catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
    cohuck@redhat.com, eric.auger@redhat.com, yuzenghui@huawei.com, 
    wangzhou1@hisilicon.com, jiangkunkun@huawei.com, 
    jonathan.cameron@huawei.com, anthony.jebson@huawei.com, 
    linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v7 1/5] arm64: Modify _midr_range() functions to read
 MIDR/REVIDR internally
In-Reply-To: <20250214151343.61348-2-shameerali.kolothum.thodi@huawei.com>
Message-ID: <7f7f34a2-8bf5-10aa-1f18-db82cc5dbf2d@redhat.com>
References: <20250214151343.61348-1-shameerali.kolothum.thodi@huawei.com> <20250214151343.61348-2-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OjGISAk5CCPfHTpQDVPHdsr4J45MAH8TAEtDUbnDvXQ_1739548972
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463806286-2135163484-1739548971=:19562"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463806286-2135163484-1739548971=:19562
Content-Type: text/plain; format=flowed; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

Hi Shameer,

On Fri, 14 Feb 2025, Shameer Kolothum wrote:
> static inline bool
> -is_midr_in_range_list(u32 midr, struct midr_range const *ranges)
> +is_midr_in_range_list(struct midr_range const *ranges)
> {
> 	while (ranges->model)
> -		if (is_midr_in_range(midr, ranges++))
> +		if (is_midr_in_range(ranges++))
> 			return true;
> 	return false;
> }

There's one more user of this:
drivers/hwtracing/coresight/coresight-etm4x-core.c:1219:13: error: too many arguments to function ¡is_midr_in_range_list¢
  1219 |         if (is_midr_in_range_list(read_cpuid_id(), etm_wrong_ccitmin_cpus)) {
       |             ^~~~~~~~~~~~~~~~~~~~~

(sr)
---1463806286-2135163484-1739548971=:19562--

