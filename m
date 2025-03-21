Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709D38F6B
	for <kvmarm@lists.linux.dev>; Fri, 21 Mar 2025 15:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742570974; cv=none; b=G9or6SMhHwXIHyyGZSWcZc4Rqv/XOCdNYGUU+dNLXMYplIIPm17N4chOy48HQLYkjmrZ77+R1FLusN7ke1yStmFM2BjHVt+dm6I4HcGjKP7bCsp6J33aVuyMl0U5EHTJ3/JM3HLf2MLztHm13NgItwACHWWzgE1g1cDd4VZB+04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742570974; c=relaxed/simple;
	bh=K+bNwhBnRFi8VVrRKLREz7cTJGTe188lLrkXlZtGrgs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gCEWLFV3QCvDZUl7+0p87PH7Y0mMsMOdB+fPF+rkw3TuXfatPCwQxXQ2gb5phMZ+rBGiiQ3j3vUcgDCT2VKH4kWwJ1wDVsgyxFXzsp3MIfYD4PgN/lujRyce0qCQWzSgw/UNT2sIISuG+ExzSQYVRcxlOX9wCVg4OSfAm+tioqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fjevIMUV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fjevIMUV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742570971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4tZTzGgPKruPQVAWMAtbqY5MZg/vcSrQFesspSXYw08=;
	b=fjevIMUVy3jnqTeBQ+qywsKZRr/Q92dNTZtFAEF+q8KHYHuok/nADGBtizVo+OQYOjBOk4
	sHn1HB9XnalX61yvdFkzq3W6jYbewRBa09CZQcdZeQqILytGLDAWFiu44f9xB2w2LjFbf4
	GtzTSHY8RZC3vR6FlZUC2q2A9b40nls=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-351-z9XOUjvyPIWnnUBBdnLNDg-1; Fri,
 21 Mar 2025 11:29:26 -0400
X-MC-Unique: z9XOUjvyPIWnnUBBdnLNDg-1
X-Mimecast-MFC-AGG-ID: z9XOUjvyPIWnnUBBdnLNDg_1742570965
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CAD31180AF50;
	Fri, 21 Mar 2025 15:29:23 +0000 (UTC)
Received: from localhost (unknown [10.67.24.51])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C0541954B04;
	Fri, 21 Mar 2025 15:29:19 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Sebastian Ott <sebott@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com, agraf@csgraf.de, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 01/14] arm/cpu: Add sysreg definitions in cpu-sysregs.h
In-Reply-To: <7c6ab887-2c9f-6646-4f0c-790671b28c62@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250311162824.199721-1-cohuck@redhat.com>
 <20250311162824.199721-2-cohuck@redhat.com>
 <7c6ab887-2c9f-6646-4f0c-790671b28c62@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 21 Mar 2025 16:29:13 +0100
Message-ID: <87v7s2tnau.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Thu, Mar 20 2025, Sebastian Ott <sebott@redhat.com> wrote:

> On Tue, 11 Mar 2025, Cornelia Huck wrote:
>> +++ b/target/arm/cpu.h
> [...]
>> +/* REG is ID_XXX */
>> +#define FIELD_DP64_IDREG(ISAR, REG, FIELD, VALUE)                       \
>> +    ({                                                                  \
>> +        ARMISARegisters *i_ = (ISAR);                                   \
>> +        uint64_t regval = i_->idregs[REG ## _EL1_IDX];                  \
>
> This won't work for regs that don't fit this naming scheme. Up to this
> point in the series that's only CTR_EL0, later with the auto generation it
> will be more. But I guess this can be extended when/if there's an actual
> need..

All ID_XXX registers fit the "has an _EL1 suffix" scheme, though, and
these are what we use the _IDREG() accessors for (we use FIELD_DP64 for
CTR_EL0 fields.) (At least, that matches what I see called "ID
registers" in the Arm Arm.)

The sysregs we get via
KVM_ARM_GET_REG_WRITABLE_MASKS/KVM_ARM_FEATURE_ID_RANGE
contain ID_XXX registers, and some more writable registers in the
feature id range which are not really id registers (but which we want to
handle via the command line as well). I think all the non _EL1 registers
we want to handle fall into the latter category (i.e. we're not going to
use the _IDREG() accessors for them?)

