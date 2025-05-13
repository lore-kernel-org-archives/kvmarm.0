Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5FA1B4159
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 09:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130234; cv=none; b=eet47l0+pnBsnziOR37m+um3qsCyrbEBo3hqFQdv2TnwKru82rAh7xN8ZiEsZVWhFa8JGwDvdQWdYPnkCKVMUTMSlLB5RzrUZ/ENZG5NzeKo8WfyUsJkC8iVXCmaYwBCHGFyOtVzqZb2uNHwWM8HV5LrxmIXl7hw+EoKftUym34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130234; c=relaxed/simple;
	bh=YnC7a/3jwBN04nZ+a9wUHK595rXowUPNwOgXxoConWA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=R6eSjK/EHjV5Mdd/YBnlgg8j2T3ugnpfe2g93zp3xqJwLdeJxr1jSwzc73yuq96McVPGt8YeSWaRwitz8RH3WxoW4sWztKLWuaDjj38j4NHPiXoRb8ME/D6T7bDXYSxp7DTf+jpA69wdxWZlHHhUiUOc31iIniz1dZeeG8PRgqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aewXmcoy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aewXmcoy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747130231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YnC7a/3jwBN04nZ+a9wUHK595rXowUPNwOgXxoConWA=;
	b=aewXmcoyoDxpLgemq3XPymlF/P55McZGesG4hTKOP864/gBm4uBZjSKLBaY59EliRfyq1z
	N1lCsMJw+Qr8NYq3qf3mGD5NcnSoqRxRUP0OXjTetjvm2x+O6TLg9dsRHHD5588HvgRBnd
	ua6TaaGudZrra1nMkeOItcDjPz0/lqw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-387-Ht71ptH-MaG1_QK-pVMAtg-1; Tue,
 13 May 2025 05:57:08 -0400
X-MC-Unique: Ht71ptH-MaG1_QK-pVMAtg-1
X-Mimecast-MFC-AGG-ID: Ht71ptH-MaG1_QK-pVMAtg_1747130226
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 81A3E1801A08;
	Tue, 13 May 2025 09:57:05 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE2861801390;
	Tue, 13 May 2025 09:57:03 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [PATCH v6 00/14] arm: rework id register storage
In-Reply-To: <7efea440-f472-4115-9133-436347632c50@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250506085234.855779-1-cohuck@redhat.com>
 <7efea440-f472-4115-9133-436347632c50@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 13 May 2025 11:57:01 +0200
Message-ID: <87h61oq1ea.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, May 13 2025, Eric Auger <eric.auger@redhat.com> wrote:

> Hi Connie,
>
> On 5/6/25 10:52 AM, Cornelia Huck wrote:
>> Just some small changes:
>> - fixed up some botched conversions noted by Eric (thanks!)
>> - rebased to current master
>> - new patch with a small cleanup suggested by Eric
>>
>> Also available at
>> https://gitlab.com/cohuck/qemu/-/commits/arm-rework-idreg-storage-v6
>
> The series looks good to me and I have not spotted any additional
> conversion issue.

Great, thanks for looking!

