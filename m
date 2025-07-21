Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CF62D5C61
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 13:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753103555; cv=none; b=mDcvUgo6oBUqmL3u08Sd3pVBWZOI2XqFHRGavpVfRGAjNWrEEcWSEokrDXCsEYO6Ob0fezQaTAHS8Frq7ubbw8pte1y/NWxooEn3AFXvjF7yXn1sl8OksESTnSbyDY08zN6vMAfTjx8m5TFwwdetivSm/W2gwVI7usnm/iK2Qqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753103555; c=relaxed/simple;
	bh=3nC713tAk8DTKDjaltrkzVufTB+8rPOtqlC2a9k6VPk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Aqar4bLXngbYI3Hilue2Zdr6/HqG4o4dEPJwQMk5/SMTACKe4lKybJFs7bVxUCEXUEX2CoD2UXG0ATOAuXfpuUNa55rm4h6X2g6nwf6YqhAWY8DcGNE8SRMi5YEPXWdpBNhv1ZsoiG7NF9lJ6/6OsWAz/EZ8EajzEXsB1PbzaNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gITmoM3D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gITmoM3D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753103552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/xaAjesXdXLCll4p8FaZte1EmjouFeib6o8XWb0yKk0=;
	b=gITmoM3Dtt7KpiKBVtlG6xtLM3rMmsUi1ao24nhjIAFTFbyVNA8uqgeZbrk9sXDyzKRDFB
	P8i/VBAf+p24xHH+A3uZ5RPfMlU7jkl3r9vyfH01v8gPAkdtu+rhE2Jfu8ZiAMgY8vRral
	SSaN+Zij5S1zTP6j2Gs3aFJx6xEDc+M=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-490-e4NUjj3YNnqAnP1qIXKlpw-1; Mon,
 21 Jul 2025 09:12:26 -0400
X-MC-Unique: e4NUjj3YNnqAnP1qIXKlpw-1
X-Mimecast-MFC-AGG-ID: e4NUjj3YNnqAnP1qIXKlpw_1753103544
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C8E4A18009F8;
	Mon, 21 Jul 2025 13:12:23 +0000 (UTC)
Received: from localhost (pixel-6a.str.redhat.com [10.33.192.205])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F35019560B3;
	Mon, 21 Jul 2025 13:12:22 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui
 Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: Re: [PATCH 6/7] KVM: arm64: Expose FEAT_RASv1p1 in a canonical manner
In-Reply-To: <86o6td8zzq.wl-maz@kernel.org>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250721101955.535159-1-maz@kernel.org>
 <20250721101955.535159-7-maz@kernel.org> <87seip67xz.fsf@redhat.com>
 <86o6td8zzq.wl-maz@kernel.org>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 21 Jul 2025 15:12:19 +0200
Message-ID: <87pldt6630.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Jul 21 2025, Marc Zyngier <maz@kernel.org> wrote:

> On Mon, 21 Jul 2025 13:32:08 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
>> 
>> On Mon, Jul 21 2025, Marc Zyngier <maz@kernel.org> wrote:
>> 
>> > If we have RASv1p1 on the host, advertise it to the guest in the
>> > "canonical way", by setting ID_AA64PFR0_EL1 to V1P1, rather than
>> > the convoluted RAS+RAS_frac method.
>> 
>> Don't the two methods have slightly different semantics with RAS == V1P1
>> possibly implying FEAT_DoubleFault, and RAS+RAS_frac not?
>
> Ah, that's an interesting point -- I definitely had glanced over that.
>
> But I'm not sure a guest can actually distinguish between these two
> configurations, given that FEAT_DoubleFault is essentially an EL3
> feature (as indicated in the RAS == V1P1 section, and further
> confirmed in R_GRJVN), making it invisible to the guest.
>
> FEAT_DoubleFault2 is, on the contrary, totally visible from the guest,
> and independent of EL3.
>
> Does this make sense to you?

It does; but it might make sense to add a comment explaining that.

Userspace should hopefully be able to just map everything to RAS == V1P1
and be done with it.

