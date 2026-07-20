Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE671D45E8
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 13:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784553694; cv=none; b=KCkjbuf76NlSc8ePAqdEbWmVPZIEzEtiqI8auiQyVz/08b+qGE9TG7ktEk6U/TSsbsEBvwclEKQ2zabtM9XMbOx5txexTJ2a6vm231bkeco/xBCwrJdCFP4ebtA43ChOg5uxEdKkG8MoXJDP5+p9nN6yiiL8331Nl3o+OibOUV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784553694; c=relaxed/simple;
	bh=el8AchH66CrsCtxyQLgD9Q82nl5ErmJKBK1z2QeRyc4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SM+/5CiVJZ4saGphWsaaVJccgLHBh2CMP2mdc1vgQOACoLofgJekkAzO4zYLXTYLhLM3gSHh/uTZ98abhHAD8CnEajpe9lw5trW/xULruhs9cuZfRBKH9yzd/ERt+cV9Oh1FUvoAdWcic0uEOdLOVD6GcMImm1imFdFw0VyW6mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KLRMIkFS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KLRMIkFS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784553692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W5z2Ohxy7/Q5eBrsLALenjrl3v+cRnifwfhebLHHq1U=;
	b=KLRMIkFSFTx+sEjS6ZBt4piynoeVNAsD5Ninr1GEjATyE5lNZRGCmLRLWJ7SNxfiJwFsvj
	wABzAtNn5wF8f1+IXCJhT49sM3aB3o+0sbgehWQKl+/91R5sTKRMx3+GpRLGo8AtCepFZg
	/D6O9jLGyNK77PyfSrSXMOazfI3itRQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-41-gEwwTBEfMXm4o1YdaonVbg-1; Mon,
 20 Jul 2026 09:21:28 -0400
X-MC-Unique: gEwwTBEfMXm4o1YdaonVbg-1
X-Mimecast-MFC-AGG-ID: gEwwTBEfMXm4o1YdaonVbg_1784553686
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27FFA195E92E;
	Mon, 20 Jul 2026 13:21:26 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 344B5300418F;
	Mon, 20 Jul 2026 13:21:24 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 8295B21E6920; Mon, 20 Jul 2026 15:21:22 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: qemu-devel@nongnu.org,  qemu-arm@nongnu.org,  kvmarm@lists.linux.dev,
  eric.auger@redhat.com,  cohuck@redhat.com,  peter.maydell@linaro.org,
  richard.henderson@linaro.org,  maz@kernel.org,  oliver.upton@linux.dev,
  berrange@redhat.com,  abologna@redhat.com,  jdenemar@redhat.com,
  gshan@redhat.com,  skolothumtho@nvidia.com,  sebott@redhat.com,
  philmd@linaro.org,  yangjinqian1@huawei.com,  shaju.abraham@nutanix.com,
  mark.caveayland@nutanix.com,  prerna.saxena@nutanix.com
Subject: Re: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
In-Reply-To: <20260716213858.609699-17-khushit.shah@nutanix.com> (Khushit
	Shah's message of "Thu, 16 Jul 2026 21:38:55 +0000")
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
	<20260716213858.609699-17-khushit.shah@nutanix.com>
Date: Mon, 20 Jul 2026 15:21:22 +0200
Message-ID: <87y0f5u78t.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Mcg9jiCy8J9kXTdrLQEb2jSvU_YvLCVy232WlW0zGNg_1784553686
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Series doesn't apply for me.  I need to apply it to be able to check
rendered documentation.  Could you push it somewhere I can pull?

