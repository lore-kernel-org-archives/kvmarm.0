Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500DD29E118
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 12:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753101145; cv=none; b=W7EjtD5NGsxg3LAzqCUJEoSi6BGY3mus93wHqCsAMdETs/btvoCta0STLzZLH/XCfFNTlsnuxovR3Vh4KdGkKw3ofl83fw7DmIP5H40gVH4TkbbB9W0781Os/2GWF/jvYe0O9lSj0DZyOg2KlAndbVF/EiWZAr6JbpZg0/R1z4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753101145; c=relaxed/simple;
	bh=ul28miSROjJXSzdS0Tc5CismYK18zOwVaBWkf5votxM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bppbXviWEsnkY+f4KUJP7sxuiBDmz/4NXmbQY5VqW4JL69eg/OUw54b9ISMLI7EqKNAUVeyppLFQyvbdScwnNGH6y/J08XV2HNKnDLwO21D6eXQr5Istn1WWK3sxKnWDMpSL4aiSXDczEOcSKqgNMii5DWbc5dTKtWrBvaEfdxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XOXx8EbW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XOXx8EbW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753101141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F6yVoIizskpBbKdog3ktrLxGca0R5J425gZKVF8sBm8=;
	b=XOXx8EbWpbSXn6JhlFsp3dFxTTnQNlN03srRbimsrAjdVRTExyN1OvNsLIdVdVnMexrNc3
	JP+E4vVTbt1TXOluuHqO3zO71VmCDyJZFSPl4CJMvggTuFuuxR19bf8dXoWoPUt3fNhpma
	uyGWWFt34Bb+cCMH/PPvW1XDEu3H9D8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-lsDY9m-DMzyRevcE2smU0A-1; Mon,
 21 Jul 2025 08:32:15 -0400
X-MC-Unique: lsDY9m-DMzyRevcE2smU0A-1
X-Mimecast-MFC-AGG-ID: lsDY9m-DMzyRevcE2smU0A_1753101133
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20FBC19560BB;
	Mon, 21 Jul 2025 12:32:13 +0000 (UTC)
Received: from localhost (pixel-6a.str.redhat.com [10.33.192.205])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B51D30001BC;
	Mon, 21 Jul 2025 12:32:11 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui
 Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: Re: [PATCH 6/7] KVM: arm64: Expose FEAT_RASv1p1 in a canonical manner
In-Reply-To: <20250721101955.535159-7-maz@kernel.org>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250721101955.535159-1-maz@kernel.org>
 <20250721101955.535159-7-maz@kernel.org>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 21 Jul 2025 14:32:08 +0200
Message-ID: <87seip67xz.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Jul 21 2025, Marc Zyngier <maz@kernel.org> wrote:

> If we have RASv1p1 on the host, advertise it to the guest in the
> "canonical way", by setting ID_AA64PFR0_EL1 to V1P1, rather than
> the convoluted RAS+RAS_frac method.

Don't the two methods have slightly different semantics with RAS == V1P1
possibly implying FEAT_DoubleFault, and RAS+RAS_frac not?

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9fb2812106cb0..549766d7abca8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1800,6 +1800,15 @@ static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>  	if (!vcpu_has_sve(vcpu))
>  		val &= ~ID_AA64PFR0_EL1_SVE_MASK;
>  
> +	/*
> +	 * Describe RASv1p1 in a canonical way -- ID_AA64PFR1_EL1.RAS_frac
> +	 * is cleared separately.
> +	 */
> +	if (cpus_have_final_cap(ARM64_HAS_RASV1P1_EXTN)) {
> +		val &= ~ID_AA64PFR0_EL1_RAS;
> +		val |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, RAS, V1P1);
> +	}
> +
>  	/*
>  	 * The default is to expose CSV2 == 1 if the HW isn't affected.
>  	 * Although this is a per-CPU feature, we make it global because
> -- 
> 2.39.2

