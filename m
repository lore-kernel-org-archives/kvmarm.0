Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F081805A
	for <kvmarm@lists.linux.dev>; Tue, 12 Dec 2023 08:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pW7OlWHx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702369255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sKNeJPFCMBBVP6/JioFHBrqv844Brw88gM4U9SoH0PY=;
	b=pW7OlWHxUouWWlmLX5RbpjVjldwRINi68j9hFeEOKdqfZvZzaSqxkdJeZvj8NZFVA0jqek
	/GaBuVzy3hXCrvR5YLLRymYhPBdb8Vmki1exMtwP6rNXafA+gLVSeF2K53tvGXQBckkvgt
	aDaK+O6VUH07LhqjbYfoYNpnOQu8SyM=
From: Itaru Kitayama <itaru.kitayama@linux.dev>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Subject: Memory requirement for kvm_page_table_test
Message-Id: <DF69CCA1-C984-448F-B360-D40AA990B64F@linux.dev>
Date: Tue, 12 Dec 2023 17:20:37 +0900
To: kvmarm@lists.linux.dev
X-Migadu-Flow: FLOW_OUT

Hi,
I see an OOM on a 4GB or memory FVP RevC model when executing =
kvm_page_table_test test.
I wonder if there's a requirement for minimal memory for this test and =
the entire kvm subsystem tests.

Thanks,
Itaru.=
