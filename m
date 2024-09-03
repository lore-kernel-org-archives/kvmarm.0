Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2045.outbound.protection.outlook.com [40.107.20.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D6A1A3AA0
	for <kvmarm@lists.linux.dev>; Tue,  3 Sep 2024 12:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.45
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725365643; cv=fail; b=DbsZZLzuwfcNGLl1fwZ9VNVu6D7enmH773F2fnid6PT6N62BtOBZuYrpeOuIvbBCEm2Mk1S/7ViLsJZ3IuIe3oGyvxIEwqTRH/ZqWfmxPkR+t/Ccwf7s322VYkHL7vvrijrXvZhepVTDCVagIBjV8++1xYOaIKA6lTW4QVVJxXY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725365643; c=relaxed/simple;
	bh=uMjmxv59KvrWHCaHDrgA2BmZK/LLsBf3qSYAa1upj+E=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bq94jJpcz91E0SDQ61CbV17AaIkGIdfHBnwd2VrKY9UWA04dYqnRcqYjA+nAs+kCsLGARIUxPqHMKfHySQqUv+RgEsCF7gNCVvJGISCOxlojME1Eb50xB1wUTBeQHcMDmRk8AA9Y2guRK1SAaQ4a4r7LCUblFlXrg0JB46z1CsU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EQ9hKuhp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EQ9hKuhp; arc=fail smtp.client-ip=40.107.20.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EQ9hKuhp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EQ9hKuhp"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=D2BNCaB40LZexxsBKx7XrwHhLacdnWBW3CblFf9dWFWQL1EUrN3vylhc2lk/IK4VOesJfM44SrvqDJdkMJdB2NhY3fPzCcC0ACNywxiuWzUl/aZLZYq9Tyf9KvzIw8hUZBcfeHG1fKMqRL2FSLaNJwiOZqQzKJZUqwimrhLdK1CFQi2wJI5eJe4fgMSJs3liOzZ9ZgaHTmPOD5eXMHFRxBwIeI5NrHJ0DguPu9gjBAsSAHUt17U8PC1WkvhdINauibatU0eXzUTwn6KpPiDwLcS2ooKdwV2WcmUa+TnTRmbeTJQRaUQNx9I9bp9wWOSyD6kMs8PQ4lcsmCgKqCHkPw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=epg425TY8ThFknnTJUOScLPyiBCiIk1XoF0wKby/ko0=;
 b=u7huNHwI9uXFmE31GLfjLeiEvgUOpDu4qjJ1soy85mgC9rEJUBz6s9LKNxjMQajVojl4wLxnJMKIEp0cj70YWNVQnNzh3zO2Ksr5+li6pa+11ugOWbF2kL4NioRvA4zzkXHlhRgiYI7Igh47kIwG3dNkpI+axRNyBCpycMVAFQiwtwvIc/+Ko+sjMHZwltcj9LssN4QQLOnIEPHA1WWOblFT330tZP6tb9L8JJBFL1wNy1BRtUUYJbppbvISoGcTZEW2qC4adPTbb4wKO5hSHo++HkMQOiTKfQeI9iQjw4UgIhoZqHzDvs19Z9fo4P4g4IXUca7vpLh3PXehGYJBjQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epg425TY8ThFknnTJUOScLPyiBCiIk1XoF0wKby/ko0=;
 b=EQ9hKuhpzcbseLYr8bvf8Hke0QJjP0BYTRxgsxHKbhuKzZ1pSf2D8UpdwXcH3SXf2D39YQe8O5bvV6U04d06aw/mzpTlF15SxYglCgKSV1koI69Ydsax1X2BFn0GAvVgwpiK1h4c57Gv2WZy6z4fVMnMr93kM9iLqlgTcWY3l/o=
Received: from AS9PR01CA0032.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:542::13) by GV2PR08MB8438.eurprd08.prod.outlook.com
 (2603:10a6:150:bc::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.12; Tue, 3 Sep
 2024 12:13:49 +0000
Received: from AM2PEPF0001C70F.eurprd05.prod.outlook.com
 (2603:10a6:20b:542:cafe::43) by AS9PR01CA0032.outlook.office365.com
 (2603:10a6:20b:542::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25 via Frontend
 Transport; Tue, 3 Sep 2024 12:13:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM2PEPF0001C70F.mail.protection.outlook.com (10.167.16.203) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Tue, 3 Sep 2024 12:13:49 +0000
Received: ("Tessian outbound 97d928cc87dc:v403"); Tue, 03 Sep 2024 12:13:49 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 28daf87b48a464b2
X-CR-MTA-TID: 64aa7808
Received: from L0abff40add27.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id C8D8A4E4-9BE0-4964-8CB7-890C598D964E.1;
	Tue, 03 Sep 2024 12:13:42 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L0abff40add27.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 03 Sep 2024 12:13:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MlpnaYD15kk8GyPjtmcvrvzHgp09h/EVNpdasxvUhKAO8nbOy0u9H8MLCDf6ZU0f+yRcTF7Y8eDsBedXdjJN5B1b+8ie+njcYRU2QpiEDPrAhVwNXNHbqmW1tOJXsT1JOLzuoxTbCuvqvkHCVh9cFhwCbdJFiJo7BHy+Q0Y5X0Z98usNbDOn+o24J+7h7ECXIeeM8dIJkqO63OdH8oFW2SK7/u5zmP3bznBZ1NQZQpXEIZ/09sxN0ESEymc5oMX8hKFf4IHa92cJ/zxpdlpCjFQip5Lv9a/oIrLydjly65PSBDB3jSe8RVbc3cI76GiWad+ORxEDdRUGcWSdlRh4aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=epg425TY8ThFknnTJUOScLPyiBCiIk1XoF0wKby/ko0=;
 b=Nx8+D42Iw+TKTLNTgGU8ixyFlJnSydM8v/bG+x8WYFK0cqsbAQwUs0pZ/0i3fvLYw+qlK+mJ35efTWL9PqbENqpxSUMQ9LvoOuUSJ2AqhQMxhIzIl8IV91nxKhF2Rqu3bFb1ZfOKcMfEfGEEl55UClcljOGSYr4oOhHtNMoEJCEL14houej2h0SAGzzESQVw/KkB0aW7muv7x5G7JoupYjC+1taQCnP4S3npoLkfVV6HddT9mnFj4lzyzcf3Gj4r+D8HEy4ykUZKmYMqllbwvfO98MKIoNrEBjAOeNjEn+tc4HfYE9UOHgyZ6cBqCNkMVcnzWaicpAPFq+uPkOBU1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epg425TY8ThFknnTJUOScLPyiBCiIk1XoF0wKby/ko0=;
 b=EQ9hKuhpzcbseLYr8bvf8Hke0QJjP0BYTRxgsxHKbhuKzZ1pSf2D8UpdwXcH3SXf2D39YQe8O5bvV6U04d06aw/mzpTlF15SxYglCgKSV1koI69Ydsax1X2BFn0GAvVgwpiK1h4c57Gv2WZy6z4fVMnMr93kM9iLqlgTcWY3l/o=
Received: from DUZPR01CA0029.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46b::18) by GVXPR08MB7678.eurprd08.prod.outlook.com
 (2603:10a6:150:3e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Tue, 3 Sep
 2024 12:13:32 +0000
Received: from DU2PEPF00028D0A.eurprd03.prod.outlook.com
 (2603:10a6:10:46b:cafe::96) by DUZPR01CA0029.outlook.office365.com
 (2603:10a6:10:46b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.26 via Frontend
 Transport; Tue, 3 Sep 2024 12:13:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DU2PEPF00028D0A.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 3 Sep 2024 12:13:30 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Sep
 2024 12:13:30 +0000
Received: from arm.com (10.1.28.157) by mail.arm.com (10.251.24.31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39 via Frontend
 Transport; Tue, 3 Sep 2024 12:13:29 +0000
Date: Tue, 3 Sep 2024 13:13:28 +0100
From: Yury Khrustalev <yury.khrustalev@arm.com>
To: Mark Brown <broonie@kernel.org>
CC: <Szabolcs.Nagy@arm.com>, <akpm@linux-foundation.org>,
	<aou@eecs.berkeley.edu>, <ardb@kernel.org>, <arnd@arndb.de>,
	<brauner@kernel.org>, <catalin.marinas@arm.com>, <corbet@lwn.net>,
	<debug@rivosinc.com>, <ebiederm@xmission.com>, <fweimer@redhat.com>,
	<hjl.tools@gmail.com>, <james.morse@arm.com>, <kees@kernel.org>,
	<kvmarm@lists.linux.dev>, <linux-arch@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-riscv@lists.infradead.org>, <maz@kernel.org>, <oleg@redhat.com>,
	<oliver.upton@linux.dev>, <palmer@dabbelt.com>, <paul.walmsley@sifive.com>,
	<rick.p.edgecombe@intel.com>, <ross.burton@arm.com>, <shuah@kernel.org>,
	<suzuki.poulose@arm.com>, <thiago.bauermann@linaro.org>,
	<wilco.dijkstra@arm.com>, <will@kernel.org>, <yury.khrustalev@arm.com>
Subject: Re: [PATCH v12 25/39] arm64/signal: Expose GCS state in signal frames
Message-ID: <Ztb9aNvPZQsRPdB7@arm.com>
References: <20240829-arm64-gcs-v12-25-42fec947436a@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240829-arm64-gcs-v12-25-42fec947436a@kernel.org>
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic:
	DU2PEPF00028D0A:EE_|GVXPR08MB7678:EE_|AM2PEPF0001C70F:EE_|GV2PR08MB8438:EE_
X-MS-Office365-Filtering-Correlation-Id: b1c49515-91ac-4439-370b-08dccc11de51
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?DZOqgoROdYpgohQ8x5V79Yx9Hbh/tdqVp2CanyPkjyfnqxjP4sr7Ww2TCcZM?=
 =?us-ascii?Q?/XQX43tCZYAfg0r+y/DdrqnXd8w4qAzvsp+DObw246XsBR6l1g+rNzmfnDKM?=
 =?us-ascii?Q?7eGI4ExOpzYuza1mL8cuk1g1EP/bwNqo+ZUdiR+A9o9faJSVcKWls1b3cZIf?=
 =?us-ascii?Q?/8/g0jzY1iyYSvrpzEULdgzbmiGruyNUhaxbgiZPr70Db/JYG7QmLxbuZH9y?=
 =?us-ascii?Q?Zc1qLikuCGCCjry2t5r0GF9+BdKyZJDUCwEQKPMMoxohiBHaYY9zGNwbai2a?=
 =?us-ascii?Q?Zt1iBXxU+Jo7VMJortGLkQcBzzxAoO+OEfF8c83mj8aJdIo9qfoYkDUI3jQO?=
 =?us-ascii?Q?riF0qdDx2yXSiK9/kc0TklwYbS5ZNUEhc/OCIyj3bIJ6JaG1tTU03WqK/g+L?=
 =?us-ascii?Q?lLCvc7bn7GKN+/tnCrOecV38aSaAJggjH65yqQos0/ZBoQWjytBVsVmev3uq?=
 =?us-ascii?Q?JDJ1krF3lsQrKSIoTpbAg7VQlhbOgGVtol8FHuimQDF/1ViXMTfzMAfD+ReZ?=
 =?us-ascii?Q?h8fl8OO8XCJx/69TeQp+hctK+0N6wVWueeZ4LE12UHfrAGoa2yfIiYXtLZnl?=
 =?us-ascii?Q?RQVJbwbhpmfBCluPuSYuK61ffDVXyBvRTunw+wl7BYiXLQS2yD+HpIMTuG8k?=
 =?us-ascii?Q?UJqLloRZuvCJAFLsVtwsh+LHcHJdmhPU8GLFjy/Hs7as6JUgnw7oNeFTN2/E?=
 =?us-ascii?Q?FwshQieBP/h0YFSvH4FTCPuC/y9ajhPIS/Ly/CSfP19f/xl41rznt4joVwbs?=
 =?us-ascii?Q?8kgR09fB1oCRSsW0kOdM177km0EgBnkg6snecaKS7W93DiDebph3/B0X7eR/?=
 =?us-ascii?Q?n9vUSH2zy02gdavFIRzy4/lFDOeqL9VwQJsQnXdggxLWOsgDb8a/jipVoePq?=
 =?us-ascii?Q?fFMslkDfxMxH5fH7uNs7MtCJKpzQjx5e50do8BN7Y1L0sdNKVw8wSaA2Jkx5?=
 =?us-ascii?Q?kuBmSuEzMLmb6Plqk1gr0XQB4ECyXSovRwYD+SLl3o/cyLzlkvwKR9Rw9RXl?=
 =?us-ascii?Q?dA/3lHmRsFQ0VIvyDxv0Z6dKPaBn6qrbdgEr9eFIhDxUGwprCKZ62BsyNuYT?=
 =?us-ascii?Q?1WL6izNDSMCNYW1qyZGEN3PYeKOo+blS1PnL34+J3Bc48g3VE7YCZCrMTZxe?=
 =?us-ascii?Q?v8dFl3cx+nZhYbfG3mp6KNd9eAB1DT9MprQnZRR7OmH4pn+KJ5JIhb/vHenZ?=
 =?us-ascii?Q?y29sOeLBLcPVGqaPxTluGCoMQj+xDS4AluJBZMIESbjdiCMb2GU7ju+TCwpb?=
 =?us-ascii?Q?NAakLrLElV7Ixnj48EHAcowo6JNZI5HfKrfB1rppST/xV2MV0OT+dkGxqi67?=
 =?us-ascii?Q?AUH+wxSeG0dRP36jgXs5ZK366qiG2CLBsz+siYZXnSx37sWavYcTVm8RPThX?=
 =?us-ascii?Q?LHL4Z9Yw6HZsdWBXY2AnMbAg5uyJIqJk1SanoRxg17RcLtFYhp5Qk1qNZHD1?=
 =?us-ascii?Q?NS0k1hrkVoLXvdicOSbhYYh+fijyt7yb?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB7678
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:10:46b::18];domain=DUZPR01CA0029.eurprd01.prod.exchangelabs.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C70F.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3008b241-3267-4aef-bb3b-08dccc11d34b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|35042699022|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9qfB7oQOOGXWog1MOYapu2snWifZIrdK54tFZ+IyPMD05ZTPLiv3Mpxa8miJ?=
 =?us-ascii?Q?NlA2NREkS+2Lh5ODJzfcEx91SDVg2OBJd3B8FkXduGOnpDGKl0uPRJ/buUhi?=
 =?us-ascii?Q?OC1kBhv8eTUSXn0wJrLa/Q6YG0jDewP5rSJsqKBHQDFtFMx9MD+CHa2Hg1cF?=
 =?us-ascii?Q?7Enqxq3+90mdZeyhbaXFrqOKCGaCCsqVT9hiOG8qL1fbdcK03vH7LGYqi9WA?=
 =?us-ascii?Q?pDm0BwrylkZgwlGr3toVgO29BeCpqa9URmRwePadGkjOroVNafkDi2Q4XEi6?=
 =?us-ascii?Q?+4mZ66N54CCa4Q2U7NQoEA+uS6wBnG3dV9LgNs2SMxgUfE9nvI2AWE7ksprV?=
 =?us-ascii?Q?X2pvDN9lhfbR7hlY1EpPGeulJH/sHpmmk2Ekgi5Ebx8tL36JWkBYbcxJPPEh?=
 =?us-ascii?Q?1hT1kCaTrTbWTZl4HpC0Jmj5aHIXqs6jB32FQNBp8/cI/yejylgImXqc7NjG?=
 =?us-ascii?Q?TTm4Ac8RDgZCI/lecbQT+Y+s1FP1tjEO0fYKjvUJ7G9RaOIML5rChUVhIPng?=
 =?us-ascii?Q?2tpNYVvRBZ9qO3o77jvXhjb+I6mKXaQzAKHwCUNuRbeM3ZbqVh38IvUy0hkD?=
 =?us-ascii?Q?PD01nRbt4nnzNDLD4/1GyQr6GG4ypvAtZGCScbMKuHR+QGlm1JHSNNwkv7pR?=
 =?us-ascii?Q?W6K/v0g6wbkQwLnPM4cwzT24+Y3NUcFrGJHkXtcLsRgQa07Wlohc+GB7Unp/?=
 =?us-ascii?Q?gp1ykxWuXodMHBP879ADDzh9wRwuYyzLbRnF0wAWU81KQCGBB6baV0mB6JIR?=
 =?us-ascii?Q?DkLYv0R3eR8BmDGmRpe4aSbwXoM8LWtpas/jjcoUnQEKGw7R5NfTpIKXk3JZ?=
 =?us-ascii?Q?RXmMc2lrsJdKuao+ugfzVopJ7jBH4m8sqck51sS4x7GOtx/L/r9q9Bo6Zaar?=
 =?us-ascii?Q?wDRH4sFso4V3zr6o/dSR1tSoue8hzMDpINAw0djvbGnoDu5MEAzkvQxX23vL?=
 =?us-ascii?Q?OhPfcuAX0bgJgSecEN4nsHi2N0VsAEbcg/WlKm4MByStxcPvZUw9b9056U6d?=
 =?us-ascii?Q?5WsjcvB2K2uzpdM6Kljhv4Q6gr90yiJvd4ovU7LOvmmRZp32SJ7Po6/yYMIL?=
 =?us-ascii?Q?xcwalAZfoWwCvwbVCPyUFqRNHQJAE84h7+Juqa8SKAAiIqyfelBE2WUJi/02?=
 =?us-ascii?Q?xhjkSISz5wUk+oMIxOeW0SGMWXA++PbVgJyjrus2OyP+5HXx3SgeIbNEgUiX?=
 =?us-ascii?Q?uPv0GDnY3I4knw+M2n6F2PPwlPDlIbha1xT5ODoU5eiMgxNXxSR0DtfJp8BM?=
 =?us-ascii?Q?QZClU7SlxZXtPgCXG5KDb4GvKCjhGme7CyHzvpS2aC37FBClI64Et5dCnu+k?=
 =?us-ascii?Q?YixgE6m083xJYEfaZJ1vVuJp7coOGNtoRgy7vaXrQlet3ZzenBqh+JqE9DA+?=
 =?us-ascii?Q?KNLlNocJIazAiAIDDQvjrg/pCbhKoBRYOgJDQPMjPsj8ZYMiD+kvUVTTPH4h?=
 =?us-ascii?Q?XNyk+H7TZn29xGSWRT3PXZ5Grah0R+e4?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(35042699022)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 12:13:49.5673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1c49515-91ac-4439-370b-08dccc11de51
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70F.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8438

On Thu, Aug 29, 2024 at 12:27:41AM +0100, Mark Brown wrote:
> Add a context for the GCS state and include it in the signal context when
> running on a system that supports GCS. We reuse the same flags that the
> prctl() uses to specify which GCS features are enabled and also provide the
> current GCS pointer.
> 
> We do not support enabling GCS via signal return, there is a conflict
> between specifying GCSPR_EL0 and allocation of a new GCS and this is not
> an ancticipated use case.  We also enforce GCS configuration locking on
> signal return.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Yury Khrustalev <yury.khrustalev@arm.com>

