Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9624963B3
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994150; cv=fail; b=DRsRoBXPeE01B+ToTt23Cw7paQub79zhVvPaRGvlpsD7SYNHECBI3ZwfJc/NZMagqOLnKlAu8POWmfoES8zELHqaN+IevlylZrmqvMd3SOCe3anQkltJs541rP6ewM7fHLQtar8CHwerQZ2ZzruSwA4UgHU2mnYfu6+pdyVM90g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994150; c=relaxed/simple;
	bh=9LUOOktzKdzlISGZ6QM/fF7LcWtVB3qQsZDganOETvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y2LuZ6VCFbLjiSAjVA6p9kpxamWfTINJJLIwrtN0MX0+Ay+7/KbeZTHbHZUQtjkWTqko81pTVMcVz3ih2mjy6lC9/e3SqbGrLYdFtmAMd9YJXZFWKk811eK0ygaNfp/ryJME81w2Gt++Ybgqhggr6f+0bj7wJtuFjUiLjuWE6Ro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=SEr+M1lU; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=x9UcAs64; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="SEr+M1lU";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="x9UcAs64"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAhghL699560;
	Mon, 21 Sep 2026 05:35:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=mUHCUjxuHXyQyiJRL0lOrQ1QNQEgu0uuU3tVxFJJg
	Io=; b=SEr+M1lUyMWAyksZHFWZVpIqpSVJQY57lOqtrDsFjkvMHEob5e3lGwbHY
	paymj3GYVwU1mbVHvor1ZsbD5IRAjGmRtDig6B+ZqFVR/FXoHQ6wnGyF7RwvxRqQ
	Sm/adsxTh8euc+ubejgWm5l8lf6o8SnTlq9jflSTiUJuNYtAKAIZTbAokBUpsS3x
	qrlZh4rNPDHEDbfuNGiQxNkpZyBGdyttW841UV6oq0IN6YJCP1aAM86P+Q9oA/m/
	P2vuNPCbZE+nNClMhBTK0RlqW7NUGpxCeGHIR9NSDX28/3jKFznUpxJe4Axavjr9
	eW4cXYoDqIcdiC3SSnGU0EaaYpLfQ==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11021122.outbound.protection.outlook.com [52.101.52.122])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gssfekdes-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:35:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WWXmPEXApseWgF/K2gr5FfRHlCZS8lEwoDqxf3mkHjDMwwkC01AABcjMYn6dOeigNb9r0/SBBPlYD955oZ+Y0l7qUG/EhukNEpnMtSoV1bDTftCyTp+cVjhMbM/Ncw67VC+/NXCJ7NyxtGsGvBfoTWJKFOr4CcDKGiRCkyT1L6xGF5ybJTLJnjE6RuznogIcCvu5RL+U+hMRPVNzz76z5jes+CMk54VXs2DiTdF3eeRJkthr8uAD7+qH2J8FZ/UtfyIbTqkkSNX74WJLYRiRnfKGD1/YNIdUdW0b/KE9kbb0dZzOM60b7cjoQgDXCvEbLqiVkRWCMJZjME5q/eXHLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUHCUjxuHXyQyiJRL0lOrQ1QNQEgu0uuU3tVxFJJgIo=;
 b=f1im26xcRRxrOsDN1F/WbsEAZpw/BPrpCLCQ4RaS/p5Za2hrSp8UfqGFB/cWtOAmdDD/5LPVfsU0ep7G69edmvRJGHHHBxQvTY709lZQXXnb1kJ/rDeEj8Wt9fdjYSwWaUWBOK9MnBYjR1jxNeNChvuvs+8dTqmw0hv4ZCOkRgi4KNxa6raRruautXwhqs62i11QCAPv/fDkW2l8vnWWXSckSbr5HDEO/d89gv0CyZiVX0X81rWABW0YifFzouwtSp32MDjlJzybc2WqYif6rjPm1sbIwpQLBq5sdVGdLjKyAswVPq5aCYXGNAe0de4vk5rTE2LoStRHpxwLZ5xANw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUHCUjxuHXyQyiJRL0lOrQ1QNQEgu0uuU3tVxFJJgIo=;
 b=x9UcAs64bWnLPfpx9J3Fp5wcyGxaz0/SZ/PdBzGjvEHZZQIqShe6qgnV+cqyEdVlht+gOF9Kbdr0W7MSujG9cGTP1F/55OALDAJWDvxHE/cFIdRPKiVYkerQgbfYLZAEaOy79jY38pjT68K42806PELpEFS4+7vZR6vehYWo/lBe1BhlXJGjFpX9XBpoi8CsdqOzbEw2q6C5stW27jmLSeF6zWOXQCQ4sxMml84qx9yD2DtB4ehVLI4U+2+B14R3AKRZR+l4k2fzMID8l8MPe4C/BEmoWmL24vPNk4D41dBjEhss106p7QTCF+AIL8RSCGHKmfYigJJzV1WLzaPjuw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB7534.namprd02.prod.outlook.com (2603:10b6:a03:320::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 12:33:22 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:22 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
        eric.auger@redhat.com
Cc: cohuck@redhat.com, peter.maydell@linaro.org, richard.henderson@linaro.org,
        maz@kernel.org, oliver.upton@linux.dev, berrange@redhat.com,
        abologna@redhat.com, jdenemar@redhat.com, gshan@redhat.com,
        skolothumtho@nvidia.com, sebott@redhat.com, armbru@redhat.com,
        philmd@linaro.org, yangjinqian1@huawei.com, shaju.abraham@nutanix.com,
        mark.caveayland@nutanix.com, khushit.shah@nutanix.com,
        ping@khushitshah.com, sandesh.patel@nutanix.com
Subject: [RFC PATCH v4 01/25] target/arm: expose SYSREG_ props for REVIDR_EL1 and AIDR_EL1
Date: Mon, 21 Sep 2026 12:32:25 +0000
Message-ID: <20260921123249.1708067-2-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260921123249.1708067-1-khushit.shah@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF0001330D.namprd07.prod.outlook.com
 (2603:10b6:518:1::1c) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|SJ0PR02MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: 20172bfe-04d7-48ad-09be-08df17dc857a
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|56012099006|6133799003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Pe6/fQTXVFjN5b/k+tP7Qs0TaqX1kIcywjbFcUvdEWMI0JCinmwlAIXZl29s/yAFibYpSBF9KJ61NRDJAxRn3i0F0+EyGkosj3lfmHQQgNoHkzXzng4f2DcRnGQFl2PdZ3NGhioIXvtKQksxWTgMQRXtrjnEctCf0hHqWbDiev5jvOQ092/TmSv8FgG4gIvuWuHg0mymlzwdMiVylFKxzV3kAH9tgi/hSu5oh2T5HEEuxKX6hN10zmN5VmY0Pe3mNJ4Bxl9qRPnQSJnTVdZCE5IQVtGZENRjdnhk1jscTV8YuirUWDPcqoVjpd5wcw9+Lcy8gyQuLJOvibNohZYXVGRc8ohp2PiYE/feG41ZEolAohvU50Axh/IH2N0exvESPALrdbSOntxqE+6DBb5BcTkA0Uefk19pNUQ8BefMoh/mMzgrWJGRTfbDPQhTBgbZudkuUXqIcAhIdM9XFoA1Vop5E2rOuyS8XEquNzfxMwK70Jpi+919scHLwt9Rk8N5tZOkJm+iZV6PUUu5yWbQ+ctWcPLjSXUGUks9EcOKsnu8zf21iInbepK1L85zmsooc+P6Mu7qM6XnStuJlYguCBaWXZH93oBDcQ74FiyFcaTuoKW1b5I1ZZ/jyfjtb/hUvPu4aBNTVcxzEOJxnokvuaXZSl7wGr55FpbJTpMfx9g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(56012099006)(6133799003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uHkrtlGspZszinKSbr56mOKSqIl4ZYOw+M6EhVPib1nMr3FUm6VEtm3nPB1B?=
 =?us-ascii?Q?JNVZtlsCx2XQn8DTlsabf41nqL5Z54We6+te2J/3QoNg9OdmWXEhTQRk9T5C?=
 =?us-ascii?Q?UVrFGmYnwXV9C1YbOE9EUjnrKxMFBRFE4kYkb4+f8g6XBxEvPIy0ibBp4Wc4?=
 =?us-ascii?Q?S2s/IjqO1aZzJzYWO+6m5qeVcyO0R+uvG7toZPxq5nSQxjaPink50W1sHnNr?=
 =?us-ascii?Q?P5M0EoOd4ne5gC5IvF6Zy+jYvR8tuAcpx+vyDBUjoQ4pnWnG0Y9wV9hyF2UK?=
 =?us-ascii?Q?RZcIIhnjJI05TYuDKx2b5v/bNcC9EFbUiOJv27jNy8/5tRXVLohZl0b2eYL4?=
 =?us-ascii?Q?B4IEggwmTm3oMVvrZ4jksSXNjA5L9amGluiYHMLKJQjPL0xNH2h3L/s/34sA?=
 =?us-ascii?Q?fQOUmkG6mYIkKo3cPROwuN/AZzzW+tpCzpeM/eE5w46vjXEDYiid3mU9H5s+?=
 =?us-ascii?Q?suxO6dyntiMg3fZxCE7QZ7tdlRdZDZ36QEM9PLnEJTXMIVZaKCghkcK8iYKP?=
 =?us-ascii?Q?O/j/AWOUmtMYdVID1ZKzkUP4UGcPjbVWJ7NeUWunSuc/BTC61qr6OgRIb7Oe?=
 =?us-ascii?Q?qlvdHMfneiNgqCRkrqODhgPdz8fSLp0VsmK5ESO6g6z/gZtuBxN6mL9OU+XA?=
 =?us-ascii?Q?KkMSn2bkJZH+uxUJWOTgmRmWelfZ/mO/ScZ6cJv2pQzI7awINSnmls42jGLg?=
 =?us-ascii?Q?a5yDyZrUSzvMJ+R+JQfQ5Agy+MQwBBlLfDTXP8eUuKjOeA5y641OYv1MS37y?=
 =?us-ascii?Q?7pTQsbh6ZjudoJs7VPAtYkydSumSS9XrOObzj52UyGxbMziapcE4SlypqsFP?=
 =?us-ascii?Q?ys6Uix3n2oM2fA+ZTmtsGx8vAUXjnO8Rxa8gK8ek785tM9KrE7eK/zPfn4q4?=
 =?us-ascii?Q?Se7lGl0ISQRs8IrqYICcMcahYq4nZWKlcQFDPJNeIhrjL+jk3mIJmWbtPUA8?=
 =?us-ascii?Q?bGL4aRRRcSKMGl32LRH6rFlURiyUUgAbeCKl4GcXAO5dT2UTVHuDp0FOjwOl?=
 =?us-ascii?Q?k1UMyHgiyp0PMbp4/IiZB/fN3llQRRiS97616JU6TMo72mSdw1fqqWgzAQC6?=
 =?us-ascii?Q?PhViLPqlDaylw8lI4JvommeVxh+RjSxZpt7F2mXbkaqCoK/0JjscRJhXkiDP?=
 =?us-ascii?Q?zjXfhYLK1EvN7cossUujLFQV/Lp+LNDIW43Xr+9nq0aX3c9oy7TG50GtMyC+?=
 =?us-ascii?Q?ZRaCtyVybyzK83PjSNtVg59XN2x2kDI6g+Q5gaz52aZWMzbWZB4DxFD/EUN5?=
 =?us-ascii?Q?b0Pi1R9mSUSKvzBZz07XwdXPodfVBYRvLaRrV9ibkHsKa5A1s6T7yV3ovh7N?=
 =?us-ascii?Q?jfbp7rYPf7Ra+P9OBa0F4lmKoOs/hPasIx6P3i3VL+5d/EuAw4TEkexw3sYY?=
 =?us-ascii?Q?jsvoB98WUfKX/KsosFn41Cc89zcNAKrGYJWJQMOjO84QrijQ/XEJZ16jhby6?=
 =?us-ascii?Q?V67yVlewLg218jJNUB42HB0Jd03Ej3nJbHHCQootxPjQcM2PfwcA7V9gxpwa?=
 =?us-ascii?Q?r/C47yCUd56uGl82/8BHFaYvj3YMdKiFHQzC7g+iA8XNW2H7F/IOfDhUw1r2?=
 =?us-ascii?Q?FpXQ80L/UEiWtzuE52kiUPaSJMIb33Lj2iY+Uy3a9S4sFd9+GePnBPac9nI6?=
 =?us-ascii?Q?NVGt2K87mj2aY3YOMz2qV/cziixKCNaRewE4rFBGQK5TsfCkJu/tdXlsE+JJ?=
 =?us-ascii?Q?LIaJpAXRF3xLnh7bRC+uFGI8vanp8nBX/8ickUqY0ynl/BkF5Q3wQrzSr2gv?=
 =?us-ascii?Q?3Elk2q4hFPQixuStay5BwMC5D4nHdGQ=3D?=
X-Exchange-RoutingPolicyChecked:
	huoquYJbBQiIagp3ApC7hEsCNAeCN3+onEBfokHmira/KA0apwbgm1RGW5MzUoqpExAD1lFK5JqoSYS1nmA8b/KjxilO/4oDdz8mIBIiGnHwt7PL7ULSdAARelA9PATMjMuMLTWe/UBkG4/sQIrHqE7mX5hYfNEof4rzOR7VsgGLmQy33Uq+jPKV6bR/iX+u3vzXTMty4fKl39rfCr9OGhnCyxrHHnaJj11S5n0RItTISHf+BS9haCI/oIzHHqspTkiapDFE1UIPsaztbfNALslzw7Je1EXhcYoOgkRsAzPvYuMHqPsp0VYA3mRY4vOla0ZsNfUBKvSriomu3VcNvg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20172bfe-04d7-48ad-09be-08df17dc857a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:22.0884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dmfg64pbGnu7oPErnJGr5f33SACT8DMaGvR9R0+YrakReWN95GlW0T1FlWU5UYaQ/kZmm1c6ANiUUCQW9JXzMl6uTdeyBZFHI3HM37WbOV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7534
X-Authority-Analysis: v=2.4 cv=dJkzC+Zb c=1 sm=1 tr=0 ts=6ab1248d cx=c_pps
 a=83jsKCSeZiZisq1MDa3xoA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22
 a=64Cc0HZtAAAA:8 a=KvCNgtYwFZ1MvR_bCnMA:9
X-Proofpoint-ORIG-GUID: b0v4auQidrhAgvbI7Q_tmQC_SCTp1g6X
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX46lP+gGcgM6n
 f3esLG+g5nNtrUKGduHS0dux5lD9CHr0AiH63vfx1Oij0ayvLV0URw/EljDW8a9yIYilPpXqPaP
 IqVLEFsJqq181hflpCSKSNuxjOHgOyM=
X-Proofpoint-GUID: b0v4auQidrhAgvbI7Q_tmQC_SCTp1g6X
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX+eMfxWte7/6b
 VWSUfnbEp6qctHivcN45OnUEPVDJTFHKiVfnT1aPL93h3ULZGpXciMjgn9UD8D4F2atnPH2IKmw
 0CqhZQKfp1dRoQ1OuE+MxR82Ktl9h4beonR8sfjXZilmRZ/qrgpdHfbFAddDPdFgdG/2ca2xG0S
 94xzwbtjLTJuWBSZempXHYwDLr8iLrspGP61f2AjVorxdyT7gRsn/Frs5sMedfxFmQ8jwEjNUBO
 kOSGmmxUwmd8vytAne+AXgkFjG/DvR3jJINoiIK+5Y6ARUfU34Dkj9uAgD1cChsYfKwBaP7KSK8
 7MdKWbEYVQ5JcnN1y5bU4qbQZdN8Ar4FfaxeM7XcWJ3gF3u/JISdkNzsnVh2cGf5H9Nt/2D/dO9
 eECGUyvrLF2uwwdDaWRFbUagdhYQY+fMm+Q61Go9RgNeOvGIOmjCVimdpDEJPVC+ek5sAc93tFw
 +MbG2AyOVImuXwO3r5Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

REVIDR_EL1 and AIDR_EL1 are implementation-defined and have no named
fields in Registers.json.

Emit dummy VAL fields covering the full register for these registers
in scripts/update-aarch64-cpu-sysreg-properties.py, then remove the
special case for these in kvm_arm_expose_idreg_properties(), exposing
them as SYSREG_ props.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 scripts/update-aarch64-cpu-sysreg-properties.py |  9 +++++++++
 target/arm/cpu-idregs.h.inc                     |  2 ++
 target/arm/kvm.c                                | 10 +---------
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/scripts/update-aarch64-cpu-sysreg-properties.py b/scripts/update-aarch64-cpu-sysreg-properties.py
index 0b4e4d3e0c..2269063408 100644
--- a/scripts/update-aarch64-cpu-sysreg-properties.py
+++ b/scripts/update-aarch64-cpu-sysreg-properties.py
@@ -246,6 +246,15 @@ def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
         # Sort decreasing lsbs
         sorted_fields = sorted(unique_fields.items(),
                                key=lambda x: x[1]['lsb'], reverse=True)
+        if len(sorted_fields) == 0:
+            # For cases like REVIDR_EL1, add a dummy field covering the
+            # full register.
+            sorted_fields.append(('VAL', {
+                'lsb': 0,
+                'msb': 63,
+                'width': 64,
+                'enums': []
+            }))
 
         for unique_key, bits in sorted_fields:
             enums_list = bits.get('enums', [])
diff --git a/target/arm/cpu-idregs.h.inc b/target/arm/cpu-idregs.h.inc
index c7e93c48b7..bc52112430 100644
--- a/target/arm/cpu-idregs.h.inc
+++ b/target/arm/cpu-idregs.h.inc
@@ -12,6 +12,7 @@
 /* IDREG_END(REG) */
 
 IDREG_START(AIDR_EL1)
+    IDREG_FIELD(AIDR_EL1, VAL, 0, 64)
 IDREG_END(AIDR_EL1)
 
 IDREG_START(CLIDR_EL1)
@@ -2438,6 +2439,7 @@ IDREG_START(MVFR2_EL1)
 IDREG_END(MVFR2_EL1)
 
 IDREG_START(REVIDR_EL1)
+    IDREG_FIELD(REVIDR_EL1, VAL, 0, 64)
 IDREG_END(REVIDR_EL1)
 
 IDREG_START(SMIDR_EL1)
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index e3a0dc07de..8a823d0324 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -554,15 +554,7 @@ void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs)
         ARM64SysReg *sysregdesc = &regs[i];
 
         if (sysregdesc->writable_mask) {
-            /*
-             * special case REVIDR_EL1 and AIDR_EL1 which are writable but
-             * do not expose named fields. They will need to be handled
-             * separately
-             */
-            if (strcmp(sysregdesc->name, "REVIDR_EL1") &&
-                strcmp(sysregdesc->name, "AIDR_EL1")) {
-                decode_idreg_writemap(obj, sysregdesc);
-            }
+            decode_idreg_writemap(obj, sysregdesc);
         }
     }
 }
-- 
2.52.0

