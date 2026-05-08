Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013046.outbound.protection.outlook.com [52.101.72.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0203F787F
	for <kvmarm@lists.linux.dev>; Fri,  8 May 2026 17:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.46
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778260170; cv=fail; b=soWBkFpBhWbqMelHK2XhG71zU67qkX5WOtp+AJj3/a9VUxoMBPSmp+6/fieCm10B8h7Lo+t7htn48jp3Dk0owff76YB3oavrUK+n0pwf/MYTiZ/gqSYc/DEQWmzrQWkQ2J+gPv94Lxwn90v4BcLzmK57HHa1C36GxjhvW3zKpA8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778260170; c=relaxed/simple;
	bh=fmmWj9q6XQsHO04NeExRu5iXM35XuDNnaWm5TjrMYbw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W15dPRDhrTY2ov2GzS9ysa7QruiSQqRe0d+x8jQt4jl6Csmanz44jL9som7H6eeXotcZlj66C1UyV0JXVTHGeMaZ9qldp3ENz7Oj8x9wk7poayMqbTtJgZEQqPP6zQnTNB4+d0Odbu//fKvL4vydrEo/VSrqvQ3nqmxCdG1EwNI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QEkHfpuW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QEkHfpuW; arc=fail smtp.client-ip=52.101.72.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QEkHfpuW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QEkHfpuW"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=E6cEW9IQFKHW/LukUgWAkErpIhUCNKyaOWc4p3znOk0eLaAwpPpWVMm09WBzvVQbIZRj3duhZtXSUzeT8/Kfzvsq0JvseJYdvAvpmLrkkaq6Y61dEFkT+PX6TnHQln36tEP0hhBKzo2zp4ojqFWRYpp6LkaBOSU88HhpW4H6UxvH1RosMIccXaOycX4M9dssYnjX5xg97tJgdJjvRBppKSy6ckGpJ9CnFdYCEbMctjyafZSFEd0RPwKYZP+Rf7BtHCwp+VOD1Eu9/njhi98Lgl1D7QPewi2JIKIfUiRMIbPdib6lWjlDMCWuwN54QkTYDyZiLy+uCraHaZW/+S1NKw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fmmWj9q6XQsHO04NeExRu5iXM35XuDNnaWm5TjrMYbw=;
 b=T5cmeobUQNhXn+sdbWRpFe2yf5yLPgyvDzKY41LSBrm5hHbMdkLcQD3HqCOhNDL4PzZUCnb7iGjcqEykJVQtlw91LBwob3I7cT4hIYvbYEofmg4SovMi6XDuCQ1RTJvxtxiedYNPq/v5GkBuO4gZQdOnu7BYiFLWamIc9j0WGSQh61mjJuOazGD2OEquh63t6u/N33TwupVTZS/5gMzoFMpo6UQ+JJFTGYgqfyFkpaDmgshqbkrlWWdR6dbUjRN/+WVZLvdEmNY7v0D8pRE1ASsGkcRHOK9WyjS3Rrr0efztiLMYYtDctta7L8g59j30hQb/jL5X8DTAls75MDFMuQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmmWj9q6XQsHO04NeExRu5iXM35XuDNnaWm5TjrMYbw=;
 b=QEkHfpuWFeQPQmZs3qLCNgdHE7gFzcx24NlI+310CJV1SRgJBzYe8pqQqYTaiNkDeLkxQ+1IWxiVPgD+e56oiP05fLSptJYBhPqbq1XlaFp1R31dh+osSDjNbB1BEehUZAWXHNM9ZoybxkE5F754kj0SYQ5ykJzOAAcVa36UHvo=
Received: from AS4P191CA0006.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d5::17)
 by AMDPR08MB11334.eurprd08.prod.outlook.com (2603:10a6:20b:717::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.19; Fri, 8 May
 2026 17:09:21 +0000
Received: from AM3PEPF00009B9F.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d5:cafe::8e) by AS4P191CA0006.outlook.office365.com
 (2603:10a6:20b:5d5::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.19 via Frontend Transport; Fri,
 8 May 2026 17:09:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9F.mail.protection.outlook.com (10.167.16.24) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9913.8
 via Frontend Transport; Fri, 8 May 2026 17:09:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OfWSwFaHuJoSmts8Gc1Q9IPb/sQ6zaoY3Cnn5tySUzRKIo3Gifb/KtpReRYgaeFFyCu5tPfYTxXWAM+430dqgD03wYHBJa0CbH6zOgXAuFon2r43LaadZTBgJGxA2TPuQ6FfNNU6Drh+vmS1cDzlGABVSdfb66jsHgRIk+x8hUE5Xo1tY8VKD1vMV7ALhPwwII8Z/TqLRwekXyNhtNqP5EP/dOuQ+S+6sRIwF1p1Dt7X2l5lZULIKnkiKGtSAMqsero/09kBa0AsM1Z6egaoNTohhJKyL67awVOuW7SguxR8oHXDWVMan3sS0XnE8LR+m9y956dZdUgWxdn+QwWhhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fmmWj9q6XQsHO04NeExRu5iXM35XuDNnaWm5TjrMYbw=;
 b=xsgqnTIXg6k8UXCh+US6pzNrk5jEP713+B6GTKod9TlTszjjsk4pNbA/Daq2GYOhfybJbvf9hNwsyhkMTrqeS8MV52Cm5ccJbgdtO1GPOdeuVT97toSdmEGCZKTv6z8p5S1uR78oHhb8JggcheJuKSZ+IMRB7SvRiPDlTp126f3YQWXJr1CYnoedmay7AkkUUBPE0oTLuoTD/wsh2TOroTNSpsnCUTRCKrWOL3xWT1X9XuOnUyx4Y1RZW+ptZTAR4w9M8qviUd15OhHeNSPumRSL8APHZcASVhY/xMJVJoe4w7O+I6LgAoQzzYlKamGMhx+Xp2/q5iPI03sF8bYuvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmmWj9q6XQsHO04NeExRu5iXM35XuDNnaWm5TjrMYbw=;
 b=QEkHfpuWFeQPQmZs3qLCNgdHE7gFzcx24NlI+310CJV1SRgJBzYe8pqQqYTaiNkDeLkxQ+1IWxiVPgD+e56oiP05fLSptJYBhPqbq1XlaFp1R31dh+osSDjNbB1BEehUZAWXHNM9ZoybxkE5F754kj0SYQ5ykJzOAAcVa36UHvo=
Received: from AM6PR08MB3399.eurprd08.prod.outlook.com (2603:10a6:20b:47::18)
 by PAXPR08MB7552.eurprd08.prod.outlook.com (2603:10a6:102:24f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Fri, 8 May
 2026 17:08:19 +0000
Received: from AM6PR08MB3399.eurprd08.prod.outlook.com
 ([fe80::59cd:4b6:fceb:3de7]) by AM6PR08MB3399.eurprd08.prod.outlook.com
 ([fe80::59cd:4b6:fceb:3de7%5]) with mapi id 15.20.9891.008; Fri, 8 May 2026
 17:08:18 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH 11/43] KVM: arm64: gic-v5: Make VPEs valid in
 vgic_v5_reset()
Thread-Topic: [PATCH 11/43] KVM: arm64: gic-v5: Make VPEs valid in
 vgic_v5_reset()
Thread-Index: AQHc1mBFVfcFFy+gpUuBzVksi2chFrX3XTeAgA0QkAA=
Date: Fri, 8 May 2026 17:08:18 +0000
Message-ID: <0b4d7e93c8cd8bf7a03d992467ae103e02fcebf7.camel@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
	 <20260427160547.3129448-12-sascha.bischoff@arm.com>
	 <86h5oszt3w.wl-maz@kernel.org>
In-Reply-To: <86h5oszt3w.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AM6PR08MB3399:EE_|PAXPR08MB7552:EE_|AM3PEPF00009B9F:EE_|AMDPR08MB11334:EE_
X-MS-Office365-Filtering-Correlation-Id: de6729bf-147e-4fcc-d9b7-08dead248c20
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 LZl+ABBW3whVQ2j2oUbYkPdUG7pAixxHrLRaL8qbmlHdWAhY42GL5jWjivUj/OnWmIR5lC4NSRkeKMR6D0iDKUaycI0CBC9topm8doiSreWp3PpbzCA0cTnOl3haa1hxi5RbA7wf24Cc+1DXTXJmU8fWYJ5nn/Dc7oQknE2i4u0yvCF762OcQB7RxZbOtKDqBFuWZCoxuSXrU8o9RH85OoctFQ+ehYUCN20GeR/qiVFk0Gg6ynyl36wyky0LSObsVm9nvR8a7aNLtDQgh7oqrHTZh2iU1qImPIferU6F1/xgYOOSaVZAD8pyH5LanmTPflXhOtycfL+deaiIndcKWqjzb8+keZwOovpE/Kt61m2MWpJqFd8OASbguA77RBBPC0pomQSWRXpnHTdsIgK3n7yWofnEH5DVOOTh8+1gMoWyv35OJiTFzk/vIOnBATFwSeCM0VSrT5O/YiAsDnVijJ31EBKaMC5zDRB72j8UPLOJ5S9cNprOP2ACNutVqfbEdhVBOs/dCikMz/00o5gdHPQc/CXcYxIjgI/7i3+/+VLT6aaARWSy19c/coyduo+zYvUIhYTRg7MfX+pmRVlMfqQXCrX3+dFrSi+D4EAN2jA6YDh9bzSLoe5RwkogNEZp9Lms79LsSo/TByDVOhWSes7wzMer7CEudeTSWydZnUcH6+18LtajFpEGzJNV4zxusi3VResHCXNxLi9gfP9zkcx4wgyQo80Nwita7ChITMcq2v946HjYi7wEAZ7wh14+
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3399.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD4DEE87B76A9F48BF55239802CC09E3@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 ZJJEFynT7jXbB2xvVeNbYsHewB/0zVncD2a+hDsNNWS+tUHJGuVQBaKsakVz0Mo5HRWZ5dFM1xQN5K6qPCrnFbu/T13ZQhOXK0jWqfRIuKcD/yVErqXEt8N4s74FDzSBHQRN0KPbBiiHsOqbdr9QljlMbnrYujywh3jdIy2Df/0TayfTj545b9GQaVhZUUKgEUsVWsydGjfU2w436zn6ZajXlrBpjJdufxfqs+niPIRKbKedXWyYl8FH04oLRiBxJjollDt/1RoZHYkTfvhTbsP7eazeovm4AXnN8r8U8o/wif2iWxHc26sVdDQcGABBwgxWdvIN6SwMB8/N1cbR+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7552
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	711f61fe-d58c-4d75-a35a-08dead2466de
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|14060799003|376014|1800799024|82310400026|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	6J4CC/yZ9aOk/UBjmXIcsoWdxSrh28xaGdte21uoUjMUheOLIVLNxvVaDhb5IILp77m5MIt5AhBWeoUAo4igzk0dJ/d90ChSkKAMfED8BtEVZWY/OAkGIqwGemlEK/OZ7vX/ViuHALQgNNUiuSRG18fp42gquuTQ8ZExqcn5jX2qeE++/YfoNDYnT4n2ebRqE+uf2PouHJ9xdl1jNPkHQbFCLcpBEMgjoiMbVo1WfQ8jFrUfR5PnVedFubVxLKKCVrkNcqqtolgBG4GWrGfm72KGSsSisujYzZL+mGg9t+nTPk3uhJuK53SZyqTPA/YFuE+Y+6XHd24cZaUqjp3VbgkMap/0roKFjUxd8j0c2OqIIWyK7e+pcioATJxTmb+Xt0ndBB1rfPrCtvsv6LyV7fen/oypDdq9p7wLQcT/Te5hUUMABYv5Q5Dl+5HvdNxLmzU3dc9uP6fG78dytL0VUpY0xxKPJCGz5q2C9TQolEsz3sHmsdLTNOwHRdmvxR2EEk/XoTUvrNSxySM9yir5RIOMENBhbjVQG2FO4kdHlUryYzgOPIebT6bySzwqVl6SEN9YwKtRP14UwbFBUHDM5lTnJCt+dWInXMfjyFaQXNd+Uai7FMhBGuRRX6eUcHQunJE9xKyPOiVQI5Hbz9fv/8sUpSTBQl/kcLgnj1JKgJ7BRGY+fWOZyqsC4uUjxbxJGnQQmJjwFgvcfcYoO29LXfAMMv2M+TplYg9oa3H22Kc=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(14060799003)(376014)(1800799024)(82310400026)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Y5pqLKxDYs3Mo5ZsTeN/T/6iu60xI9Eqtj2inBqXdgrdM8JDw5vwodwyg4q5GPkgjDpo3ngooGofxoDn4KXz/qehT0eQK7M2lZrPBFwXDcBj55dqNYMwmHE7ks1BdErlbotEjQyYwhDz+nPgOvh78Qea8lYPFu0WeTy5PTXHRW8NEurv9q3PJTG2rNqjvcrUxQknZGzeJfSCzARFO0qfrsAhnCS+2v5y8asYdO5PJs011M9ocq3yw8cjnfkt9J2+3Na3+1IeCeNp5AHRKM2iFFHLYKh3l2cRm8/vBLmCcSDJZgDC4C7ewzWsSqPsM5FqZZGtsi34xc0bJpXWMrOgnDKadctlxaMambHb4rC3ElA+FYLm3IO0VRTUcJzWOsBOR93tkdHOG8luwr/iP94lqCVGKgTwIlC3OoUbi4Iu28+ivzcRj7iirq9OPKLIRxjT
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 17:09:21.3516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de6729bf-147e-4fcc-d9b7-08dead248c20
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB11334

T24gVGh1LCAyMDI2LTA0LTMwIGF0IDEwOjM3ICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIE1vbiwgMjcgQXByIDIwMjYgMTc6MDk6NDcgKzAxMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IFdoZW4gcmVzZXR0aW5n
IFZQRXMsIGFsc28gbWFyayB0aGVtIGFzIHZhbGlkIGluIHRoZSBWTSBWUEUgVGFibGUuDQo+ID4g
VGhpcw0KPiA+IGlzIHJlcXVpcmVkIGFzIGl0IGluZm9ybXMgdGhlIElSUyB0aGF0IGEgc3BlY2lm
aWMgVlBFIG1heSBiZSBtYWRlDQo+ID4gcmVzaWRlbnQsIGFuZCB3aXRob3V0IHRoaXMgdGhlIElS
UyB3aWxsIHRyZWF0IHRoZSBWUEUgYXMgaW52YWxpZC4NCj4gPiANCj4gPiBBcyBwYXJ0IG9mIHRo
aXMgY2hhbmdlLCB3ZSBhbHNvIGludHJvZHVjZSBhIHdyYXBwZXIgYXJvdW5kIHRoZSBWUEUNCj4g
PiBkb29yYmVsbHMgLSB2Z2ljX3Y1X3NlbmRfY29tbWFuZCgpLiBUaGlzIHRha2VzIGEgc3RydWN0
IGt2bV92Y3B1DQo+ID4gcG9pbnRlciwgYW5kIHRoZSBjb21tYW5kIHRvIHJ1biwgYW5kIHRyaWdn
ZXJzIHRoZSBmdW5jdGlvbiBib3VuZCB0bw0KPiA+IHRoZSBjb21tYW5kIHZpYSB0aGF0IHZjcHUn
cyBkb29yYmVsbC4gVGhpcyBpcyBhIGNvbnZlbmllbmNlDQo+ID4gZnVuY3Rpb24NCj4gPiB0byBz
aW1wbGlmeSB0aGUgY29kZS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hv
ZmYgPHNhc2NoYS5iaXNjaG9mZkBhcm0uY29tPg0KPiA+IC0tLQ0KPiA+IMKgYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLXY1LmMgfCAyMiArKysrKysrKysrKysrKysrKysrKysrDQo+ID4gwqAxIGZp
bGUgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNo
L2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2lj
LXY1LmMNCj4gPiBpbmRleCAwNjQ5NzI5ZjZiODM0Li45MmJiNjNiNmRkNmJiIDEwMDY0NA0KPiA+
IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gKysrIGIvYXJjaC9hcm02
NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBAQCAtNTE4LDYgKzUxOCwxOCBAQCBzdGF0aWMgaW50
IHZnaWNfdjVfaXJzX3ZwZV9jcjBfdXBkYXRlKGludA0KPiA+IHZtX2lkLCBpbnQgdnBlX2lkLCB1
MzIgY3IwKQ0KPiA+IMKgCXJldHVybiAwOw0KPiA+IMKgfQ0KPiA+IMKgDQo+ID4gK3N0YXRpYyBp
bnQgdmdpY192NV9zZW5kX2NvbW1hbmQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiA+ICsJCQkJ
ZW51bSBnaWN2NV92Y3B1X2luZm9fY21kX3R5cGUNCj4gPiB0eXBlKQ0KPiA+ICt7DQo+ID4gKwlz
dHJ1Y3QgZ2ljdjVfY21kX2luZm8gY21kX2luZm87DQo+ID4gKw0KPiA+ICsJaWYgKCF2Y3B1KQ0K
PiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiANCj4gRHJvcCB0aGlzLiBJZiB3ZSBtdXN0IGNyYXNo
LCBsZXQncyBjcmFzaCBlYXJseSwgaW4gdGhlIG1vc3QNCj4gc3BlY3RhY3VsYXIgd2F5LCBhbmQg
bGVhdmluZyBhIGJhY2t0cmFjZS4gVHJ5aW5nIHRvIGdyYWNlZnVsbHkgaGFuZGxlDQo+IHRoaXMg
c3R1ZmYgaXMgbWFraW5nIGl0IGhhcmRlciB0byB0cmFjayBhbmQgZGVidWcgc3VjaCBwcm9ibGVt
cy4NCg0KT0ssIG5vdGVkLg0KDQo+IA0KPiBBbHNvLCBpZiB3ZSBtYWRlIGl0IHRoYXQgZmFyLCBp
dCBpcyB2ZXJ5IGxpa2VseSB0aGF0IHZjcHUgaXNuJ3QgTlVMTC4NCg0KWWVhaCwgaW4gd2hpY2gg
Y2FzZSB0aGUgYmFja3RyYWNlIGlzIGNlcnRhaW5seSBtb3N0IHVzZWZ1bC4NCg0KPiANCj4gPiAr
DQo+ID4gKwljbWRfaW5mby5jbWRfdHlwZSA9IHR5cGU7DQo+ID4gKwlyZXR1cm4gaXJxX3NldF92
Y3B1X2FmZmluaXR5KHZnaWNfdjVfdnBlX2RiKHZjcHUpLA0KPiA+ICZjbWRfaW5mbyk7DQo+ID4g
K30NCj4gPiArDQo+ID4gwqBzdGF0aWMgaW50IHZnaWNfdjVfZGJfc2V0X3ZjcHVfYWZmaW5pdHko
c3RydWN0IGlycV9kYXRhICpkYXRhLA0KPiA+IHZvaWQgKnZjcHVfaW5mbykNCj4gPiDCoHsNCj4g
PiDCoAlzdHJ1Y3QgdmdpY192NV92bSAqdm0gPSBkYXRhLT5kb21haW4tPmhvc3RfZGF0YTsNCj4g
PiBAQCAtNjkxLDYgKzcwMyw4IEBAIHN0YXRpYyB2b2lkDQo+ID4gdmdpY192NV90ZWFyZG93bl9w
ZXJfdm1fZG9tYWluKHN0cnVjdCB2Z2ljX3Y1X3ZtICp2bSkNCj4gPiDCoA0KPiA+IMKgdm9pZCB2
Z2ljX3Y1X3Jlc2V0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiDCoHsNCj4gPiArCWludCBy
YzsNCj4gPiArDQo+ID4gwqAJLyoNCj4gPiDCoAkgKiBXZSBhbHdheXMgcHJlc2VudCAxNi1iaXRz
IG9mIElEIHNwYWNlIHRvIHRoZSBndWVzdCwNCj4gPiBpcnJlc3BlY3RpdmUgb2YNCj4gPiDCoAkg
KiB0aGUgaG9zdCBhbGxvd2luZyBtb3JlLg0KPiA+IEBAIC03MDIsNiArNzE2LDE0IEBAIHZvaWQg
dmdpY192NV9yZXNldChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gwqAJICogQ1BVSUYgKGJ1
dCBwb3RlbnRpYWxseSBmZXdlciBpbiB0aGUgSVJTKS4NCj4gPiDCoAkgKi8NCj4gPiDCoAl2Y3B1
LT5hcmNoLnZnaWNfY3B1Lm51bV9wcmlfYml0cyA9IDU7DQo+ID4gKw0KPiA+ICsJLyogTWFrZSB0
aGUgVlBFIHZhbGlkIGluIHRoZSBWUEVUICovDQo+ID4gKwlyYyA9IHZnaWNfdjVfc2VuZF9jb21t
YW5kKHZjcHUsIFZQRV9NQUtFX1ZBTElEKTsNCj4gPiArCWlmIChyYykgew0KPiANCj4gbml0OiBy
YyBzZXJ2ZXMgbm8gcHVycG9zZSBoZXJlLiBKdXN0IHdyaXRlIGl0IGFzOg0KPiANCj4gCWlmICh2
Z2ljX3Y1X3NlbmRfY29tbWFuZCguLi4pKQ0KPiANCj4gPiArCQkvKiBXZSBjYW4ndCBjb250aW51
ZSwgc28gbWFyayB0aGUgVk0gYXMgZGVhZCAqLw0KPiA+ICsJCWt2bV92bV9kZWFkKHZjcHUtPmt2
bSk7DQo+ID4gKwkJcmV0dXJuOw0KPiANCj4gQnV0IHdlIHByb2JhYmx5IHNob3VsZCBkdW1wIHNv
bWUgdHJhY2VzIGhlcmUsIHJhdGhlciB0aGFuIHNpbGVudGx5DQo+IG1hcmsgdGhlIFZNIGFzIGZz
Y2snZC4gVEhpcyBpcyB0aGUgc2lnbiB0aGF0IHNvbWV0aGluZyBoYXMgZ29uZSB2ZXJ5DQo+IHdy
b25nLg0KDQpPSywgSSd2ZSBjaGFuZ2VkIHRoaXMgdG8gZHJvcCB0aGUgcmMsIFdBUk5fT04sIGFu
ZCByZXR1cm4uDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IAlNLg0KPiANClRoYW5rcywNClNhc2No
YQ0K
