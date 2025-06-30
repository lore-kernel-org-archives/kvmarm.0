Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2DC248F48
	for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 10:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751277885; cv=none; b=YyWemxeJY3Fu8TWe25vHeRQ6BofKRiiVIx+S7lUaBhIvjZ35rIn0pApgpntAuh9Ho8aLHPseUN7AwDIuokpkEVMA2uxlCjdjB2l0mNqpMVZ6gb/RJVebDy3UNDmwqyqO7blR4etHGq3djvqtuiRdztFTUhV1kEh8Zp4olTJ4/aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751277885; c=relaxed/simple;
	bh=U/hPt3HnxEXyebzfSxmkUb8PNFKGWn36uaYbFZYkdAc=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nIYIITUEbN05BaNeRL+BjC+WmRXIC+osD8tqFjFCq1U/YDO1+yGZeMpvt1NZTrXQoroj4LwhmJc6KmcC+/fCD42S9+tG4Qoq587M/pZL5E0VA1z17w2M4noO5XR8ssoH/YATYCg+2ca2QQVJI9JRpbePgVt0VIuLTbf+CRI7+2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jzq+aPp8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jzq+aPp8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751277882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rjChr4l7bDoOse0Y08kwZF8ENfM0mEbxnZ8orFyHQAs=;
	b=Jzq+aPp8X2RzLLBvsWhjKmHnbxkBi2GI8mKe1CWG9jYytfYJFxruRnEnBwfjHj1xhudSMq
	RntJgp4g3/zYnUOWn/C5GBlQc+HDhB5GsS09eNdDaldhjzoLngTElqtl4j9t8inTbFjEZS
	EDSnPXw1zclffVzNjAQiXqIB3Ju5EZQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-597-dE_8xuvEPCeE7rJ1WeK2eg-1; Mon,
 30 Jun 2025 06:04:38 -0400
X-MC-Unique: dE_8xuvEPCeE7rJ1WeK2eg-1
X-Mimecast-MFC-AGG-ID: dE_8xuvEPCeE7rJ1WeK2eg_1751277877
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03DB61978F63;
	Mon, 30 Jun 2025 10:04:36 +0000 (UTC)
Received: from localhost (dhcp-192-236.str.redhat.com [10.33.192.236])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7ABC918003FC;
	Mon, 30 Jun 2025 10:04:33 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de
Subject: Re: [PATCH v8 00/14] arm: rework id register storage
In-Reply-To: <20250617153931.1330449-1-cohuck@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250617153931.1330449-1-cohuck@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 30 Jun 2025 12:04:30 +0200
Message-ID: <87jz4tr1e9.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


On Tue, Jun 17 2025, Cornelia Huck <cohuck@redhat.com> wrote:

> Mostly addressed Peter's feedback:
> - make sure every inbetween stage compiles (also fixed some bonus issues)
> - try to make the scripts more robust, add a note the generated file,
>   and make sure to grab only registers we actually want
>   - I did a half-hearted attempt to use python instead of awk, but I'm
>     out of my depth, especially with the script that will be used for
>     the register fields in the cpu models series
>
> Also available at
> https://gitlab.com/cohuck/qemu/-/commits/arm-rework-idreg-storage-v8

This still seems to apply cleanly... can it go in as-is, or should I
respin to shorten the long line in kvm.c?

