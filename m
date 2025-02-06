Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991B1213240
	for <kvmarm@lists.linux.dev>; Thu,  6 Feb 2025 10:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738836438; cv=none; b=pRRd2N659dL6+KBUVPsC38KHoymdo/2MlHqGNaL0iSkOsD9M3N2BVvhEr3v2BhWflw9SJmLF0v/rYKkXI+jDr9kOGN/17iLGGalzCk6/18dddrLdAr+d6znsjdXOlY7CNu6bhM6wBNuqtUBMMhohV73dXLrwRu1ciwvCA34Lvag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738836438; c=relaxed/simple;
	bh=Ft8yFaba32UBbhOaPcB2V8a0+WveLzP6vbuUVjp/cJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YID4RSyugNhiJPNQ3rWpYYDh4b7OhCuRCi/816nNLNyitAusOwHIwDH/k6f9pKsGq0I3O67NEADhl9IXpXi7SkE0FgBMzx+9BumDE9uT5LNFpthR/xiRI71ofbinbwYFEienzxqpqQmA2iM+pWX0zpiwJ2PjMpb18AGj95fgSi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qy0RRzFJ; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qy0RRzFJ"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4679b5c66d0so138161cf.1
        for <kvmarm@lists.linux.dev>; Thu, 06 Feb 2025 02:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738836433; x=1739441233; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/hMOv1jb3VuPjbiScymll9/U6EJUmVQD7oiX7iZhovg=;
        b=qy0RRzFJd0dhUCM7CVuZnR1LKuRzXdSiBbQlVI7WPSBGsiq2ibHAdP345mpSHNoZv5
         wpg/m48BmDodfsimJTe7Ac1kVoJMO6tVqyw3oM6s5sJeaRX9gMRI7aDfsXbAqKbn3aqL
         4fyzjgnJjk0low+YkgW0+7agOh6xVex4epDffip5zCe+TGEoaE8sYBBWUCP+zRMGOYRH
         x+sFkdtF4Mlj8sLD82A0NmZU6UGTfmxY1qO0vLWUngR7/k9QJF9h2UIXpZzG4V3HfnMM
         e0iXFrcrPUItvc/8YWvCrRMsQqU9rywW+7C8ulM8QHpARVRXP8DfurkWIj/ii1LnQ+Id
         A4ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738836433; x=1739441233;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/hMOv1jb3VuPjbiScymll9/U6EJUmVQD7oiX7iZhovg=;
        b=NBxuIPT66K21dPDdlKWQ6okywLuPs95PygK67NnTe+jIST4B2lNI6qpUBth6J2v4DY
         rNwbRaqk5voZR93w0hZnpeJmBzlerLUruqNVbUnrpr1dp8xuFdBh99jI2vUfrObtdaDj
         EoXK3qtOWiUAiFAroIKcB/qmvJvpGj0hhEDdzuNVgf6SkiFvAj8Oo+9AOY8dcVuj30k7
         5MhfrEf5L3KlG0Xa0awviAEgfcWGhnBlMlKvQcOyN387ozoyi6V8A7n7Ue0aP1bCbADJ
         oUIKt65LDqtU6Jf9dxNM7u8V+iop3NrXuMdenq19aIaW5x2yvPFpbQTgcuPkw1BJr4SP
         9jYA==
X-Gm-Message-State: AOJu0YzlrtO3MevpwmCVEsfLfw2GP4+UlYQu4/7QzBxyY2UhhA4iVASo
	CC/78D9pbiLTajUcSJGu2Iy50PvmDsEapGuNX+gJsV4msVD5scd7vkzMninhCF039LTo2S3hNee
	sXzJzuu4mBNviv5gm/zHGMRTNYZBlYf5PseeF
X-Gm-Gg: ASbGncvBvoDmisZk9NnSdMNaXPSFws6wuCcpRyGPBLpOqIMoNAN809aICL1KY6AGBP9
	EpXue/fdXuPxbaT9qr+wqE5MEdD7s28mmvONejBjiNqre2f8zH8QUeUAwd8xUd7lKwlxKw79FY1
	AbzGytfo1Jg47JSttcBeo9/MF24g==
X-Google-Smtp-Source: AGHT+IH7CMMID4cSHU3JyQA1yD502OP2lyUHARrV2rOUCIgzeExRxsu/yfaZpg4ohoWCS0xMVOFuIEIBlqd1tS63DMw=
X-Received: by 2002:a05:622a:1ba6:b0:46c:7cf2:d7b2 with SMTP id
 d75a77b69052e-470ffb717fdmr2168741cf.18.1738836433235; Thu, 06 Feb 2025
 02:07:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250205164630.1706058-1-tabba@google.com> <86tt98tjdt.wl-maz@kernel.org>
In-Reply-To: <86tt98tjdt.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 6 Feb 2025 10:06:36 +0000
X-Gm-Features: AWEUYZlnvh44VeRTCLkSAtqEhkC3ry9OGtsov074CBIdjnCXpvNC5_jNMjMRqCw
Message-ID: <CA+EHjTyFNgQQnDQ6pm2V0gyFrXG3OOmW_9mYDi_bdq79VdqS=A@mail.gmail.com>
Subject: Re: [PATCH v1] arm64: head.S: Do not trap access to MPAMSM_EL1
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	james.morse@arm.com, jingzhangos@google.com, anshuman.khandual@arm.com, 
	shameerali.kolothum.thodi@huawei.com, gshan@redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Wed, 5 Feb 2025 at 17:02, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 05 Feb 2025 16:46:27 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Bit 50 of MPAM2_EL2, EnMPAMSM, traps access to MPAMSM_EL1 when 0,
> > as per ARM ARM DDI DDI0487L.a, section D24.12.3. Therefore,
> > ensure it is set to 1 for the host to disable the traps.
>
> But what makes use of this register in the kernel? I can't find any
> trace of it in 6.14-rc1.

I understand that MPAM support in the kernel isn't there quite yet.
Also, regarding enabling access to a register at EL1, without the
whole framework for enabling MPAM, might be problematic. It makes more
sense for this to be part of the work to add MPAM support, which I
believe James might be working on.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
