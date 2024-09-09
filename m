Received: from mx.astralinux.ru (mx.astralinux.ru [89.232.161.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B822176FDF;
	Mon,  9 Sep 2024 10:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.232.161.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725878407; cv=none; b=dway/Ke6HqqjR24RxbQ3PjHLlJczNsSNJhrvrNOxRD/RO9Lcdy/xCoaSvV3zvcRAqCJKFttX+hCDo7EMLxk3LtV0egUOCd8UbQmWvW+V8mZKRyVgDsr7V1sPzq7v39101SoQWw7Alb433YE4HLzyGK3ZVKNyQH5XTcgxEFRegOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725878407; c=relaxed/simple;
	bh=nhmogqEJBAtSAuuVlYizhQquMvjqMofQzBvi/STMDJg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Nr/jo1w/ACj6/12AYAPeJWdjGEgNLvq6NPznrumdMEShGdQCupRZvcT3SKsxSuDsOTCKdPB0MlzoibfhqsrOnMQjNkuPgMGhP3WwkZvdFAgvldtEclm3wHxcdm97Kg8u5v27VByvsSiEgDD+GU65OGK+N0FV05rxz7Um0Wt9hAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; arc=none smtp.client-ip=89.232.161.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Received: from [10.177.185.111] (helo=new-mail.astralinux.ru)
	by mx.astralinux.ru with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <abelova@astralinux.ru>)
	id 1snbml-00BGaJ-H4; Mon, 09 Sep 2024 13:38:19 +0300
Received: from rbta-msk-lt-106062.astralinux.ru (unknown [10.198.22.134])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4X2NcZ6F73z1c0X1;
	Mon,  9 Sep 2024 13:39:26 +0300 (MSK)
From: Anastasia Belova <abelova@astralinux.ru>
To: Marc Zyngier <maz@kernel.org>
Cc: Anastasia Belova <abelova@astralinux.ru>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Matt Evans <matt.evans@arm.com>,
	Christoffer Dall <christoffer.dall@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	stable@vger.kernel.org
Subject: [PATCH 0/2] arm64: KVM: prevent overflow in inject_abt64
Date: Mon,  9 Sep 2024 13:38:26 +0300
Message-Id: <20240909103828.16699-1-abelova@astralinux.ru>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DrWeb-SpamScore: 0
X-DrWeb-SpamState: legit
X-DrWeb-SpamDetail: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehuddgtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfftfghgfeunecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeetnhgrshhtrghsihgruceuvghlohhvrgcuoegrsggvlhhovhgrsegrshhtrhgrlhhinhhugidrrhhuqeenucggtffrrghtthgvrhhnpeffvddvueehvedvgfeivdeuvdduteeulefgfeehieffgfehtedutdfgveefvdeiheenucffohhmrghinheplhhinhhugihtvghsthhinhhgrdhorhhgnecukfhppedutddrudelkedrvddvrddufeegnecurfgrrhgrmhephhgvlhhopehrsghtrgdqmhhskhdqlhhtqddutdeitdeivddrrghsthhrrghlihhnuhigrdhruhdpihhnvghtpedutddrudelkedrvddvrddufeegmeefheeifeekpdhmrghilhhfrhhomheprggsvghlohhvrgesrghsthhrrghlihhnuhigrdhruhdpnhgspghrtghpthhtohepudehpdhrtghpthhtohepmhgriieskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprggsvghlohhvrgesrghsthhrrghlihhnuhigrdhruhdprhgtphhtthhopeholhhivhgvrhdruhhpthhonheslhhinhhugidruggvvhdprhgtphhtthhopehjrghmvghsrdhmohhrshgvsegrrhhmrdgtohhmpdhrtghpthhtohepshhuiihukhhirdhpohhulhhoshgvsegrrhhmrd
 gtohhmpdhrtghpthhtohephihuiigvnhhghhhuiheshhhurgifvghirdgtohhmpdhrtghpthhtoheptggrthgrlhhinhdrmhgrrhhinhgrshesrghrmhdrtghomhdprhgtphhtthhopeifihhllheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepmhgrthhtrdgvvhgrnhhssegrrhhmrdgtohhmpdhrtghpthhtoheptghhrhhishhtohhffhgvrhdruggrlhhlsehlihhnrghrohdrohhrghdprhgtphhtthhopehlihhnuhigqdgrrhhmqdhkvghrnhgvlheslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehkvhhmrghrmheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlvhgtqdhprhhojhgvtghtsehlihhnuhigthgvshhtihhnghdrohhrghdprhgtphhtthhopehsthgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghenucffrhdrhggvsgcutehnthhishhprghmmecunecuvfgrghhsme
X-DrWeb-SpamVersion: Dr.Web Antispam 1.0.7.202406240#1725640479#02
X-AntiVirus: Checked by Dr.Web [MailD: 11.1.19.2307031128, SE: 11.1.12.2210241838, Core engine: 7.00.65.05230, Virus records: 12165305, Updated: 2024-Sep-09 08:42:30 UTC]

Add explicit casting to prevent expantion of 32th bit of
u32 into highest half of u64.

Found by Linux Verification Center (linuxtesting.org) with SVACE.
