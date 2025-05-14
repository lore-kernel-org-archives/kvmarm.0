Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF39191F6C
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 15:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747237033; cv=none; b=WFtwPr2A5lm4QAiYyp9hrFUvsvubEqPur4+ZE21itMeBQrcb5i6UavG5/4PAWlzAzoeYgrsmdYqA1jkbdhqHTGW5fUomXGdN7eRSd9bb/MiKuEZZvEtHyjj4owLIWnYqxGwxLfKZKF3zjgyr3PUZHszGASARpP+BAm+JbXuLi9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747237033; c=relaxed/simple;
	bh=Wrzn9zgKuq/oV5w+DfMdKNo7AOzFTdxgefUwS90Ru+Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hCvG/T79EX6YCQ11fNP+MPc32rVsq3XaL2hbTqUiauydSPJ6fDmor9X5xG7ebzGCTuWM23Y3PI21pdvQC3tFzWiagWqvVwBUkAEJfzTCWezHnI+oL7luP7VMTApjshdplSpttWsNZ2+voE42HrSCYMDHxMoOehuuL0d6zUiUdJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y59z4dos; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y59z4dos"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747237030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rNqpKMDVkRLgudOp61Ys+LEkD187I+q8Zkd/KYUyD+A=;
	b=Y59z4dosBrHGE9Ou9nUu0aL+mKtSjaL0s1STcSrIWSN1SMluudC6C1RywP/0GvE8m+J/uM
	HNOfBVBUOFJcjgOQu2b9VmHPGBOz/GmL1dSUysDJrzDPsFGRZwbJj0tIs+pHo6FUloRMaY
	Y9fhWwTxXdd37vYhAay/QDPQl0OgnWI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-8-jyKCLfMyKwIM9GNFW6lg-1; Wed,
 14 May 2025 11:37:07 -0400
X-MC-Unique: 8-jyKCLfMyKwIM9GNFW6lg-1
X-Mimecast-MFC-AGG-ID: 8-jyKCLfMyKwIM9GNFW6lg_1747237025
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 745621955DB1;
	Wed, 14 May 2025 15:37:02 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DDB421955BC0;
	Wed, 14 May 2025 15:37:00 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 abologna@redhat.com, jdenemar@redhat.com, agraf@csgraf.de,
 shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [PATCH v3 08/10] arm/cpu: more customization for the kvm host
 cpu model
In-Reply-To: <aCNsSbDoi5oKWYul@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-9-cohuck@redhat.com> <aCNsSbDoi5oKWYul@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Wed, 14 May 2025 17:36:58 +0200
Message-ID: <875xi3cig5.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, May 13 2025, Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:

> On Mon, Apr 14, 2025 at 06:38:47PM +0200, Cornelia Huck wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>>=20
>> If the interface for writable ID registers is available, expose uint64
>> SYSREG properties for writable ID reg fields exposed by the host
>> kernel. Properties are named  SYSREG_<REG>_<FIELD> with REG and FIELD
>> being those used  in linux arch/arm64/tools/sysreg. This done by
>> matching the writable fields retrieved from the host kernel against the
>> generated description of sysregs.
>>=20
>> An example of invocation is:
>> -cpu host,SYSREG_ID_AA64ISAR0_EL1_DP=3D0x0
>> which sets DP field of ID_AA64ISAR0_EL1 to 0.
>
> For the value you are illustrating 0x0 - is this implying that
> all the flags take an arbitrary integer hex value ?
>
> This would be different from x86, where CPU feature flags are
> a boolean on/off state.

Most of the fields are 4 bits, the allowed values vary (there are also
some fields that are single bits, or wider.) The FEAT_xxx values (which
can be expressed via ID register fields, or a combination thereof) are
mostly boolean, but there are also some of them that can take values.

We could cook up pseudo-features that are always on/off, but I don't
like that approach: they would be QEMU only, whereas the ID register
fields and FEAT_xxx features are all defined in the Arm documentation.

An additional difference from x86 would be that FEAT_xxx featues are not
neccessarily configurable (only if the host kernel supports changing the
ID register field(s) backing the feature.)

