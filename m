Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C065217B425
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 14:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747406537; cv=none; b=g9Exh4NwBH/gMB2oGqWG4gEKUolNTKErsTyC6l1vyRkub2g95Vm+TQaweEvhoyyuAkabIjs/hlLOA/iCZcUrylQsv9vto00YQuJA9/GxBAN0OWWCcfnGJsSRPay4abUOGyaPLTyuST7isy6HnqiayoeY/lKN5rVxJg1XXohMKdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747406537; c=relaxed/simple;
	bh=psZ4AyiaNf999izpbtF0gY/nHaTfKe3K8bPtC7X9BTM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WlH1EhTLJFpr0DcQu97tXVJSjVbED/D63FSKl/siLh8Oef7drFpyPwrBOVkZ54/kn3sf0uKa0Mf7RHqtXPX7NSYnKgNNMCAH9m3XrJR/cZo6CBTBGMViRxiJvSeSzxFEfT5SUDUgd6Q8edmVxAmLv/YRO7jutQNy4lv7itsu++0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NbwJm8UR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NbwJm8UR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747406534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sD306+wR2Yr1QYUWd0Nza6XnFdZAYxmZP8qIvKeNGlI=;
	b=NbwJm8URiR8TvwGFEFEQxS1YUU2fqZGvdETB3eyjGZ4sQQulluQnUdq9VCCf2zYD4lMANl
	NjRdh2Qzn2Z7TW4WBURwSwUUUZLEkBH+ZtbhjtVyz0Lpy82sv5BjdshoykeT14jAWcSTVF
	/87JcJ/uqPJDf89OjMJHJY+fUF55NUU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-456-0LuNbzh8McSoZzd5gePpdA-1; Fri,
 16 May 2025 10:42:11 -0400
X-MC-Unique: 0LuNbzh8McSoZzd5gePpdA-1
X-Mimecast-MFC-AGG-ID: 0LuNbzh8McSoZzd5gePpdA_1747406529
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C6811956094;
	Fri, 16 May 2025 14:42:08 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 389DB30075D5;
	Fri, 16 May 2025 14:42:06 +0000 (UTC)
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
In-Reply-To: <aCNrtM2U7OBKsnjQ@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-9-cohuck@redhat.com> <aCNrtM2U7OBKsnjQ@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 16 May 2025 16:42:03 +0200
Message-ID: <87y0uwbosk.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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
> Functionally this works, but stylewise it is rather too verbose
> IMHO. I understand this aims to mtch the arm feature names, but
> we can at least drop the SYSREG_ prefix here which IMHO doesn't
> add much value. The <REG> component only has a small number of
> possible prefixes, so it seems pretty unlikely we would get a
> name clash between these and some other QOM property.

The main reason for the SYSREG_ prefix was to make implementation of the
query interface easier; I'll see if we can implement it differently. (We
might want to think about how we handle it differently anyway.)

>
> Also could we stick with lowercase, rather than uppercase. I
> appreciate the spec uses uppercase, but that doesn't concern
> itself with end user usage. If we just plain transform everything
> to lowercase, there's still a clear mapping to the spec that
> people will understand [1].

Did you forget to include [1]? :)

I agree that a lowercase conversion wouldn't make things too hard to
find in the docuementation.

>
> This example uses '-cpu host', but does this also work
> with '-cpu max'  ?
>
> Conceptually '-cpu max' is supposed to be functionally identical
> to '-cpu host' when KVM is enabled. Obviously you'd ned to
> exclude it from '-cpu max' with TCG or other non-KVM accels.

For KVM, this works with -cpu max as well, as it falls through to -cpu
host implicitly. aarch64_host_initfn() is basically split into KVM and
HVF parts, so HVF will already do the right thing (i.e. not support it),
as will tcg (which uses a separate init function.)

>
>
>> +/*
>> + * decode_idreg_writemap: Generate props for writable fields
>> + *
>> + * @obj: CPU object
>> + * @index: index of the sysreg
>> + * @map: writable map for the sysreg
>> + * @reg: description of the sysreg
>> + */
>> +static int
>> +decode_idreg_writemap(Object *obj, int index, uint64_t map, ARM64SysReg=
 *reg)
>> +{
>> +    int i =3D ctz64(map);
>> +    int nb_sysreg_props =3D 0;
>> +
>> +    while (map) {
>> +
>> +        ARM64SysRegField *field =3D get_field(i, reg);
>> +        int lower, upper;
>> +        uint64_t mask;
>> +        char *prop_name;
>> +
>> +        if (!field) {
>> +            /* the field cannot be matched to any know id named field */
>> +            warn_report("%s bit %d of %s is writable but cannot be matc=
hed",
>> +                        __func__, i, reg->name);
>> +            warn_report("%s is cpu-sysreg-properties.c up to date?", __=
func__);
>
> What scenario triggers this warning ? Is this in relation to QEMU
> auto-detecting host CPU features, as opposed to user -cpu input ?

The kernel making something writable, but we haven't updated
cpu-sysreg-properties.c via the script. As I'd expect regs/fields to be
added to sysreg much earlier than KVM making them writable, we'll
probably not see much of this warning in practice (only if you run a
really old QEMU version with a cutting-edge kernel.) This has mostly
triggered for me when I had messed up something while writing the code
:)

This is not user-input triggered, so maybe we should log it differently,
as the user can't really fix this themself?

