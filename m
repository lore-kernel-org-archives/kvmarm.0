Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C911DED4B
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 16:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730132754; cv=none; b=mMJmB7iYEyoGl8ALJITX7IcGjeOU3QTVlpa1rgb+0zlMOfBnoxQY0ZB7BygUD4cqSnmPGcrMZ81rTDaVX6+eUjo/PLZLLYPcsOUCDL76qw3sleJV2kCyw+edLhaS0m84cIamphS4MIJVOz5meBtuDJZZsFTTHLDNIlhKNBoIvD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730132754; c=relaxed/simple;
	bh=M+2gqHrBWTXyVsuXuBLviV+kGBT501Q3yJUEWkFuoRo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lL4KhLE34fDlAsL+xgxkAZtuT/dQvjIEPD3/LC54eWibflkSrDQiQRimSC8ET6aJnPR4AvwoCOCIEvc/dTihTFVLZnuiGJh3NAN7fShZHwuTA4wezIOLbDjaX3bTRXDRBRu+yEDIxodFRp1juIBrk5gJIu/Up30T9wUri/Onu+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FeCLyCWE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FeCLyCWE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730132751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lLqWpqg4o8JwULxrDm11ytWwnKy/wVBsVBtOzOxjOQs=;
	b=FeCLyCWERnd/76TuowbAW99Nsl68LnqU+XOHXvjjNp/w8uSkALjXutERO3FY7YjO+CBc4s
	4+ZIN+AxH5qMemAoQDEWBI85B2eQ+hJIZBo45b83D69CMMnYWHojgtAA4N1bs7m0KV0qbF
	WzLq8IRYzdoqyKRWSNnyviJ76pZ2RjY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-602-RGD58N-WO1ieLy_dmCpbnQ-1; Mon,
 28 Oct 2024 12:25:47 -0400
X-MC-Unique: RGD58N-WO1ieLy_dmCpbnQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BC351955EE7;
	Mon, 28 Oct 2024 16:25:44 +0000 (UTC)
Received: from localhost (unknown [10.22.88.106])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 26CA019560A3;
	Mon, 28 Oct 2024 16:25:42 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>, =?utf-8?Q?Daniel_P=2E_Berran?=
 =?utf-8?Q?g=C3=A9?=
 <berrange@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 abologna@redhat.com, jdenemar@redhat.com, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
In-Reply-To: <CAFEAcA_wQu17y0PyQwxw0wuf2H5y2VE5aX16nLP2-u7QUP2ggA@mail.gmail.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-19-eric.auger@redhat.com>
 <ZxuX4i9NjVRizB72@redhat.com>
 <cb6c8f62-c5dc-416d-865f-fbdf96164dac@redhat.com>
 <Zxub7ol4p8P_sWF8@redhat.com>
 <CAFEAcA_wQu17y0PyQwxw0wuf2H5y2VE5aX16nLP2-u7QUP2ggA@mail.gmail.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 28 Oct 2024 17:25:40 +0100
Message-ID: <87sesgnqij.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Oct 28 2024, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Fri, 25 Oct 2024 at 14:24, Daniel P. Berrang=C3=A9 <berrange@redhat.co=
m> wrote:
>> On Fri, Oct 25, 2024 at 03:18:25PM +0200, Eric Auger wrote:
>> > On 10/25/24 15:06, Daniel P. Berrang=C3=A9 wrote:
>> > > Also, is this naming convention really the same one that users
>> > > will see when they look at /proc/cpuinfo to view features ? It
>> > No it is not. I do agree that the custom cpu model is very low level. =
It
>> > is very well suited to test all series turning ID regs as writable but
>> > this would require an extra layer that adapts /proc/cpuinfo feature
>> > level to this regid/field abstraction.
>> >
>> > In /cpu/proc you will see somethink like:
>> >  Features    : fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp
>> > asimdhp cpuid asimdrdm lrcpc dcpop asimddp
>>
>> Right, IMHO, this is the terminology that QEMU must use in user
>> facing APIs.
>
> /proc/cpuinfo's naming is rather weird for historical
> reasons (for instance there is only one FEAT_FP16 feature
> but cpuinfo lists "fphp" and "asimdhp" separately).
> Currently QEMU only has to care about cpuinfo name tags
> in linux-user/elfload.c where there's a bunch of data
> structures for "what hwcaps do we need to advertise
> given what the CPU has?". I would definitely prefer it if
> we could use architectural feature names...
>
> On other architectures do we do anything to forbid
> invalid combinations? For Arm there are architectural
> rules about feature X requiring features Y and Z.
> Are we going to just let the user create a CPU that
> the guest OS will barf on if they want to? (The
> user-experience for that is potentially not very nice,
> because something like "-cpu cortex-a57,+sve" seems like
> something you might want to do but isn't actually valid;
> even listing the direct required dependency of FEAT_SVE
> like "-cpu cortex-a57,+sve,+fp16" isn't sufficient
> because SVE is optional-from-v8.2 and so a guest could
> in theory assume the presence of anything mandatory in
> v8.1 and v8.2. But even merely diagnosing invalid
> combinations is a huge pain, and automagically pulling
> in every mandatory implicit or explicit dependency
> seems like it might be surprising to users, as well as
> being annoying to implement. Currently we sidestep
> all of these problems by (a) only allowing the command
> line to disable a feature, not to enable it where it
> didn't previously exist and (b) mostly not providing
> command line flags for individual features...)

I think s390 does some dependency checking on features, and also rejects
features that are "too new".

