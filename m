Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11E41C3BE7
	for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 15:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734104630; cv=none; b=oPgAxqdpUJ7KXvcdqeWnSeD35fWPwejVftYCAW+P8MYP0nE70PhS3atryNLwByhOVtQegLT2zaMdBRmuAIdfT7zk4qKoVs/Chwfi7JoKng4Y1qiDVy4ZkebtSH0GtirNFRARmlvFhO+W9ivLvdoK9YhntnBL7R4tSPb7gSGmSYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734104630; c=relaxed/simple;
	bh=RYU/4FdKkB0xorZ2TsYbbW9T90/h6t9JRgfYUWysE+s=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EJjOTqzlCIWGeI03j4jII13mHtc9N9hS50GPbo+MkdmshGeQcD96WewQbGaSlzSystwPnznDMXb9iiNTjmKbMFumE4F5FsQwIFJAq3Dmw0/w4GducPXY6rpOzrmSbgk3h3cqr5Kq22rGcs+dOWJvlWTgs/uE/I9fQFUyG2+uBLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fW1kJB62; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fW1kJB62"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734104627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RYU/4FdKkB0xorZ2TsYbbW9T90/h6t9JRgfYUWysE+s=;
	b=fW1kJB62hOL0/qouCH4pZTxbRUxT/29xnU36TQ038gXhMSOTZz99gJSNfbWLqgryRwvgkp
	E1wBOTpyvYl23GRzrJT4CGRlHNIhAWYh0iGzVdOPU0Ck1ROTAGkoqViO9Li3oL9FOKiJqf
	34z9njiwqaR4dalvDr5E8qe+2xsGTho=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-a3xUOItJNimu-9lRPDa6NA-1; Fri,
 13 Dec 2024 10:43:41 -0500
X-MC-Unique: a3xUOItJNimu-9lRPDa6NA-1
X-Mimecast-MFC-AGG-ID: a3xUOItJNimu-9lRPDa6NA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D4951955E9C;
	Fri, 13 Dec 2024 15:43:40 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A04D9195605A;
	Fri, 13 Dec 2024 15:43:38 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
 eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev
Subject: Re: [PATCH RFCv2 01/20] kvm: kvm_get_writable_id_regs
In-Reply-To: <f06b5f10-6ff4-4851-96db-56d6596bd176@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241206112213.88394-1-cohuck@redhat.com>
 <20241206112213.88394-2-cohuck@redhat.com>
 <a1ad71d4-4148-42ee-b77a-fc4df1f5c2c0@linaro.org>
 <f06b5f10-6ff4-4851-96db-56d6596bd176@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 13 Dec 2024 16:43:35 +0100
Message-ID: <875xnnd1w8.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Dec 12 2024, Eric Auger <eric.auger@redhat.com> wrote:

> Hi Richard,
>
> On 12/12/24 14:59, Richard Henderson wrote:
>> On 12/6/24 05:21, Cornelia Huck wrote:
>>> +#define NR_ID_REGS (3 * 8 * 8)
>>> +
>>> +typedef struct IdRegMap {
>>> +=C2=A0=C2=A0=C2=A0 uint64_t regs[NR_ID_REGS];
>>> +} IdRegMap;
>>> +
>>
>> Where does the NR_ID_REGS come from?=C2=A0 In particular the * 3?
>> IIRC, all of the id registers are in op0=3D3, op1=3D0, crn=3D0, crm=3D{0=
-7},
>> op2=3D{0-7}.
>
> According to the KVM API and code,
>
> "The Feature ID space is defined as the AArch64 System register space
> with +op0=3D=3D3, op1=3D=3D{0, 1, 3}, CRn=3D=3D0, CRm=3D=3D{0-7}, op2=3D=
=3D{0-7}."
>
>
> hence that choice
>
> See:
> https://lore.kernel.org/all/20230919175017.538312-3-jingzhangos@google.co=
m/
>
> Definitively we can add a comment

I've added

/*
 * ID registers in op0=3D=3D3, op1=3D=3D{0,1,3}, crn=3D0, crm=3D=3D{0-7}, o=
p2=3D=3D{0-7},
 * as used by the KVM_ARM_GET_REG_WRITABLE_MASKS ioctl call.
 */

