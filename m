Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172A722541F
	for <kvmarm@lists.linux.dev>; Wed,  2 Jul 2025 09:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751446902; cv=none; b=tmXUVawl2ohvQvW63uSLH6S7PlnEtpHkM/G3ZH3T81Y3nuPXOQsdK5cl9z53CexjaP0/v54wZYVng4uVAFhMe2DjuxUR6j6/75yeZ00dQw0oq2VALGk7MrOajn74ZxI6baSJ0xOVNh6um/G2EwXttymovHUdOxjX3hOqtQzf59s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751446902; c=relaxed/simple;
	bh=d+kQul6R0lGd1wxb4o77UWDFa/jjXRqLzsaVV/fmKXI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CBUJlDEOYTK+pjWemu/8fXccB+ViJphdEmv9w+WAe9fFOe/fRdAo0p+jhhfCJTx8eVdI2IFMEVqI5ruwyJNVIJjMXFknxjG/8rn5IomV6XzASFTsYN2TEiRFgQY1na9+xn9VcAVMMeDJjIMcsx1IND9FhnFVsjeBLuGYxSbciE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MoirCfsC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MoirCfsC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751446899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d+kQul6R0lGd1wxb4o77UWDFa/jjXRqLzsaVV/fmKXI=;
	b=MoirCfsChmBZBL3LzqBYTLBox51+SqMxiVMZ3ZHLodQhCIwBG6ZvXX0QARqftPKh1xyBo3
	uE50RzSfjOdDDgIApzlEgfMN0wIiYY0aguXuyPcxcT0UWOX9Iig8oPMP+n/qNUmq+jC60W
	5/3Dgzjc0TSIveRSbIVRs+GscnljB4c=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-184-B_5uyoxXPSGnO1NBkZVZrQ-1; Wed,
 02 Jul 2025 05:01:36 -0400
X-MC-Unique: B_5uyoxXPSGnO1NBkZVZrQ-1
X-Mimecast-MFC-AGG-ID: B_5uyoxXPSGnO1NBkZVZrQ_1751446894
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD28D1809C80;
	Wed,  2 Jul 2025 09:01:33 +0000 (UTC)
Received: from localhost (dhcp-192-236.str.redhat.com [10.33.192.236])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 493741956048;
	Wed,  2 Jul 2025 09:01:32 +0000 (UTC)
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
In-Reply-To: <CAFEAcA8+OjptoJgPDeQkw5TQtVduhq-KvP-Br6JNDmW57jgXbw@mail.gmail.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250617153931.1330449-1-cohuck@redhat.com>
 <20250617153931.1330449-14-cohuck@redhat.com>
 <CAFEAcA9OXi4v+hdBMamQv85HYp2EqxOA5=nfsdZ5E3nf8RP_pw@mail.gmail.com>
 <87bjq3rj3a.fsf@redhat.com>
 <CAFEAcA8+OjptoJgPDeQkw5TQtVduhq-KvP-Br6JNDmW57jgXbw@mail.gmail.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Wed, 02 Jul 2025 11:01:29 +0200
Message-ID: <875xgbq846.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Jul 01 2025, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Tue, 1 Jul 2025 at 17:07, Cornelia Huck <cohuck@redhat.com> wrote:
>>
>> On Mon, Jun 30 2025, Peter Maydell <peter.maydell@linaro.org> wrote:
>>
>> > On Tue, 17 Jun 2025 at 16:41, Cornelia Huck <cohuck@redhat.com> wrote:
>> >>
>> >> Generated against Linux 6.15.
>> >>
>> >> Reviewed-by: Sebastian Ott <sebott@redhat.com>
>> >> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> >> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> >
>> > Stripping out all the lines that just moved around,
>> > here are the additions:
>> >
>> >> +DEF(ID_AFR0_EL1, 3, 0, 0, 1, 3)
>> >
>> > This is ARMCPU::id_afr0. If we want to store this in
>> > the idregs[] array that's fine but we ought to move it.
>> >
>>
>> I guess the *afr* regs fell into the cracks because they were not in the
>> isar struct -- makes sense to move them.
>>
>> (This reg "must be interpreted with" MIDR_EL1; I'm wondering if that has
>> any implications once we enlighten guests with possible midr/revidr/aidr
>> values.)
>
> It just means that the contents are entirely implementation
> defined, so you can't tell what they mean unless you first
> look at MIDR_EL1 to find out what your implementation is.

Would we need to provide multiple afr options then once we allow to
specify multiple values of MIDR and friends?

>
> (Linux doesn't appear to ever look at the AFR0 registers.)

Or ignore it for now...

>
>> >> +DEF(ID_AA64PFR2_EL1, 3, 0, 0, 4, 2)
>> >
>> >> +DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
>> >
>> >> +DEF(ID_AA64DFR2_EL1, 3, 0, 0, 5, 2)
>> >
>> > These are all ID registers we don't implement yet
>> > because we don't implement any features that are
>> > described in them (i.e. our implementation is RAZ/WI).
>> > I guess it's OK to list them here, though we won't
>> > do anything with the array entry.
>>
>> I don't think it hurts to include them, it makes things easier when we
>> want to deal with non-zero values in there via kvm.
>>
>> >
>> >> +DEF(ID_AA64AFR0_EL1, 3, 0, 0, 5, 4)
>> >
>> > ARMCPU::id_aa64afr0
>> >
>> >> +DEF(ID_AA64AFR1_EL1, 3, 0, 0, 5, 5)
>> >
>> > ARMCPU::id_aa64afr1
>> >
>> >> +DEF(ID_AA64ISAR3_EL1, 3, 0, 0, 6, 3)
>> >
>> >> +DEF(ID_AA64MMFR4_EL1, 3, 0, 0, 7, 4)
>> >
>> > More ID regs for features we don't implement yet.
>> >
>> >> +DEF(CCSIDR_EL1, 3, 1, 0, 0, 0)
>> >
>> > CCSIDR_EL1 isn't a single ID register, it's an array
>> > of them (indexed by CCSELR_EL1). We keep them in
>> > ARMCPU::ccsidr[]. I don't think it makes sense to
>> > have an entry in isar.idregs[] for this.
>>
>> Hm, IIUC, kvm gets the correct CCSIDR_EL1 under the covers already
>> (i.e. no array).
>
> There's support in the KVM GET_ONE_REG API for reading
> and writing the full array (see KVM_REG_ARM_DEMUX_ID_CCSIDR).
> We just don't bother in QEMU at the moment because we never
> need the values in userspace.

We could manually exclude things like CCSIDR_EL1, but is it worth the
effort if it's simply present?

>
>> >> +DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
>> >
>> > ARMCPU::clidr
>> >
>> >> +DEF(CCSIDR2_EL1, 3, 1, 0, 0, 2)
>> >
>> > This is an array too.
>>
>> Currently, kvm handles this as undef.
>
> That seems like a missing feature in KVM -- it ought to be
> implemented on anything where ID_AA64MMFR2.CCIDX says
> we have FEAT_CCIDX (which means that the whole cache ID
> format changes and the info is split between CCSIDR
> and CCSIDR2).
>
>> >> +DEF(GMID_EL1, 3, 1, 0, 0, 4)
>> >
>> > Another ID register for a feature we don't yet implement
>> > (and a slightly oddball one in that it should UNDEF
>> > until we do implement FEAT_MTE2).
>> >
>> >> +DEF(SMIDR_EL1, 3, 1, 0, 0, 6)
>> >
>> > We implement this as a fixed zero in helper.c.
>>
>> Undef in kvm.
>
> Probably because KVM doesn't have support for SME in
> guests yet ?

Once we do get support for it in kvm, it would make sense to have it in
place already, and it probably won't conflict with the fixed definition
in tcg code, right?

>
>> >
>> >> +DEF(DCZID_EL0, 3, 3, 0, 0, 7)
>> >
>> > We construct the value of this one in aa64_dczid_read()
>> > based on ARMCPU::dcz_blocksize plus some runtime info.
>>
>> That one's another bit of a headache (I didn't manage to spot kvm code
>> dealing with it.)
>
> The hardware handles it for you -- inside the guest, the
> value of the DZP bit depends on HCR_EL2.TDZ (and maybe also
> SCTLR_EL1.DZE). The value of DCZID_EL0.BS has to match the
> real host CPU anyway because you can't change the block
> size that the DC ZVA insn is going to use. (You could
> trap DCZID_EL0 accesses via HFGRTR_EL2.DCZID_EL0 if you really
> wanted to, but you'd also need to trap-and-emulate the
> DC ZVA insns, which is a lot of effort for something
> no guest is really going to notice the difference on.)

So I guess it wouldn't hurt to include this in the array?

My basic question is: Do we need to exclude certain registers from being
included in the autogenerated list and derived code? (On the flip side,
once we add the code that discovers registers writable via kvm, we also
found that we need some registers not in the source file...)

