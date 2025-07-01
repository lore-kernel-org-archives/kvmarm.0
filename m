Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2525815AF6
	for <kvmarm@lists.linux.dev>; Tue,  1 Jul 2025 16:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751386022; cv=none; b=MnDkOfHdz/BglPfNghimiyimuF/KtIoYZ/T640vDi//f0eTF2K9i0MdXUwR+EdOLrz1M8LjImhq24zfeBtqqgf7SflGYBtqna1ZvFseB0UIxz9BVYGA6irhWpv8cCWYCjNQ4D9yLHPdcV03EnwH6VZDo+JRWk3hDJA/VQ1YWJOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751386022; c=relaxed/simple;
	bh=OANjoBvVLf6xMXLThwWS0hhZV0+SpHpMDNDI4sHOTSQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nGKb8O5DrV/b4Bck4fH+TKJVAUAs5Vn+BbT+oHx8RvTp3Jno6jDHO0fp7o308AJiGsjXx70PSxhmKjiryw4dVR/Ieg4PUa/09lCC92fRgcpWyGiSGDTAqqfJTQ2JRbwoiIE5UG+45ORl6JFBcdix3wkYB17yP4Sg881IEceQCis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cb45bsbP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cb45bsbP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751386019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OANjoBvVLf6xMXLThwWS0hhZV0+SpHpMDNDI4sHOTSQ=;
	b=cb45bsbP2cSPjmmYU2YpLSKHdREgOSIUbBql+MsNK1oOhuiJHrbykFnDVFylv+LhGzmaxV
	fzLxWILPlEYTTcFy/KJG5I8WzsqyK8msfAv2dz/KhO91MRYgDUrKbM8GtVhU3guze5QzP6
	QHhpdE2V9NsdVCI8NNj7rKhv6Irg8Nc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-0VCybmYhOPOIp4N0ampxqw-1; Tue,
 01 Jul 2025 12:06:57 -0400
X-MC-Unique: 0VCybmYhOPOIp4N0ampxqw-1
X-Mimecast-MFC-AGG-ID: 0VCybmYhOPOIp4N0ampxqw_1751386015
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2832719560A2;
	Tue,  1 Jul 2025 16:06:54 +0000 (UTC)
Received: from localhost (dhcp-192-236.str.redhat.com [10.33.192.236])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BEC191800284;
	Tue,  1 Jul 2025 16:06:51 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com, agraf@csgraf.de, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v8 13/14] arm/cpu: switch to a generated cpu-sysregs.h.inc
In-Reply-To: <CAFEAcA9OXi4v+hdBMamQv85HYp2EqxOA5=nfsdZ5E3nf8RP_pw@mail.gmail.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250617153931.1330449-1-cohuck@redhat.com>
 <20250617153931.1330449-14-cohuck@redhat.com>
 <CAFEAcA9OXi4v+hdBMamQv85HYp2EqxOA5=nfsdZ5E3nf8RP_pw@mail.gmail.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 01 Jul 2025 18:06:49 +0200
Message-ID: <87bjq3rj3a.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Jun 30 2025, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Tue, 17 Jun 2025 at 16:41, Cornelia Huck <cohuck@redhat.com> wrote:
>>
>> Generated against Linux 6.15.
>>
>> Reviewed-by: Sebastian Ott <sebott@redhat.com>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>
> Stripping out all the lines that just moved around,
> here are the additions:
>
>> +DEF(ID_AFR0_EL1, 3, 0, 0, 1, 3)
>
> This is ARMCPU::id_afr0. If we want to store this in
> the idregs[] array that's fine but we ought to move it.
>

I guess the *afr* regs fell into the cracks because they were not in the
isar struct -- makes sense to move them.

(This reg "must be interpreted with" MIDR_EL1; I'm wondering if that has
any implications once we enlighten guests with possible midr/revidr/aidr
values.)


>> +DEF(ID_AA64PFR2_EL1, 3, 0, 0, 4, 2)
>
>> +DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
>
>> +DEF(ID_AA64DFR2_EL1, 3, 0, 0, 5, 2)
>
> These are all ID registers we don't implement yet
> because we don't implement any features that are
> described in them (i.e. our implementation is RAZ/WI).
> I guess it's OK to list them here, though we won't
> do anything with the array entry.

I don't think it hurts to include them, it makes things easier when we
want to deal with non-zero values in there via kvm.

>
>> +DEF(ID_AA64AFR0_EL1, 3, 0, 0, 5, 4)
>
> ARMCPU::id_aa64afr0
>
>> +DEF(ID_AA64AFR1_EL1, 3, 0, 0, 5, 5)
>
> ARMCPU::id_aa64afr1
>
>> +DEF(ID_AA64ISAR3_EL1, 3, 0, 0, 6, 3)
>
>> +DEF(ID_AA64MMFR4_EL1, 3, 0, 0, 7, 4)
>
> More ID regs for features we don't implement yet.
>
>> +DEF(CCSIDR_EL1, 3, 1, 0, 0, 0)
>
> CCSIDR_EL1 isn't a single ID register, it's an array
> of them (indexed by CCSELR_EL1). We keep them in
> ARMCPU::ccsidr[]. I don't think it makes sense to
> have an entry in isar.idregs[] for this.

Hm, IIUC, kvm gets the correct CCSIDR_EL1 under the covers already
(i.e. no array).

>
>> +DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
>
> ARMCPU::clidr
>
>> +DEF(CCSIDR2_EL1, 3, 1, 0, 0, 2)
>
> This is an array too.

Currently, kvm handles this as undef.

(I think the whole cache stuff might be a bit of a headache.)

>
>> +DEF(GMID_EL1, 3, 1, 0, 0, 4)
>
> Another ID register for a feature we don't yet implement
> (and a slightly oddball one in that it should UNDEF
> until we do implement FEAT_MTE2).
>
>> +DEF(SMIDR_EL1, 3, 1, 0, 0, 6)
>
> We implement this as a fixed zero in helper.c.

Undef in kvm.

>
>> +DEF(DCZID_EL0, 3, 3, 0, 0, 7)
>
> We construct the value of this one in aa64_dczid_read()
> based on ARMCPU::dcz_blocksize plus some runtime info.

That one's another bit of a headache (I didn't manage to spot kvm code
dealing with it.)

I'll move the *afr* ones, not yet quite sure how to deal with the cache
related ones.

