Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8081F131D
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 10:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729851745; cv=none; b=fJektIjbFOpfDqGyKrox0B3xZ163Z7FlEvIP3neXD4sXn42ydISAVt48YK/o/j4u8X5M1qqRjo+nCK/wqkcAdID4mWVaqK48S9QZHnsH7tN4TN4BIiPFDEmXYUNW9jop8bKPCADWwn3BXPfEvEfgA4n3AeR6lvplZXk5p1uJmvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729851745; c=relaxed/simple;
	bh=FaL89K/dkPjEpVG7i/QEejtsjshuZOsB0w0Ehi11pEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oab5Teg+lkEjg7pM9gFLBVUGbd90GkhlGGajMnlQs0GEHn7BnRV8Tml3290+ahggwjnQxEkid3uXgCJiIXZJk5qZFl1kV9Gn5hvjH46EhgSOlJ6hEFIWP+aae7U//QjtUm6V7ACVFGBwZ/OP2EUJPXEVFzCXeLEjYCd5a4abdsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YJ1V1jS9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YJ1V1jS9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729851741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oe6BKi/vAtAI+FnjeShPy/q5uBG++u0rJX+QId15yp8=;
	b=YJ1V1jS9913B8cr0anFvNzAhTi6DRirhFLxFivGaj8AbctSTjBPiuCBphJa54ZAfoAYDPv
	yGk1doR1/1mcArrNz0dIj6x3uW/XmY3t95B0qvhB2X7a6t3x3IZ3FN4BHRpzoE0ZbHYH+G
	42HQJZUB8qfCdwKb4RbxcD21UEf6MKE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684--TImg_t-Ofqy92fVKxNUJA-1; Fri,
 25 Oct 2024 06:22:18 -0400
X-MC-Unique: -TImg_t-Ofqy92fVKxNUJA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E842195609E;
	Fri, 25 Oct 2024 10:22:16 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.194.5])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 013E2196BB7E;
	Fri, 25 Oct 2024 10:22:10 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	cohuck@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Cc: shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com
Subject: [RFC 19/21] virt: Allow custom vcpu model in arm virt
Date: Fri, 25 Oct 2024 12:17:38 +0200
Message-ID: <20241025101959.601048-20-eric.auger@redhat.com>
In-Reply-To: <20241025101959.601048-1-eric.auger@redhat.com>
References: <20241025101959.601048-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Cornelia Huck <cohuck@redhat.com>

Allowing the use of the custom vcpu model in ARM virt.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 hw/arm/virt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index b0c68d66a3..edde4b5007 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -3052,6 +3052,9 @@ static void virt_machine_class_init(ObjectClass *oc, void *data)
 #if defined(CONFIG_KVM) || defined(CONFIG_HVF)
         ARM_CPU_TYPE_NAME("host"),
 #endif /* CONFIG_KVM || CONFIG_HVF */
+#ifdef CONFIG_KVM
+        ARM_CPU_TYPE_NAME("custom"),
+#endif /* CONFIG_KVM */
 #endif /* TARGET_AARCH64 */
         ARM_CPU_TYPE_NAME("max"),
         NULL
-- 
2.41.0

