Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013039.outbound.protection.outlook.com [52.101.83.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A863F9F56
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 15:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774969823; cv=fail; b=BfR9v7Ng/K7+DHz7rCr0WbB0WnM0V9GtXDXr9g1C4zNdPi7nGjfV5DkL4iCGBXG9ZLXF873ZMIoL3u2F05l/lie8P99vooPe8teQ7u6eATpWYe56gL7hXbivlOLaxVWUtTObMv6u4p/XWc2mzHGqgl9dj86NFcWhoCgJi4+eOo0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774969823; c=relaxed/simple;
	bh=UzBYq6RaY6NFYpTUVNHA245ENvUipVMb7aoWROfq4Sc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XrGyE2TY2UAi8fDwxZRxfV9fQ7hScSM1PCLsDZh206hZ7ScjfFuhjHstWjah1S6bWKyK/3b58CbKujhmIZc4G2Vsa9sBUOD9GRIdvrUnhnC4quM/d93gmdAcBGOh/9VzlXovkmIBFicZ88saeNaNdaTPb57xi/Ma+4PdxEFKNoE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GwTS/nhq; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GwTS/nhq; arc=fail smtp.client-ip=52.101.83.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GwTS/nhq";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GwTS/nhq"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=jYyTx+NL0M6cCjNsjHyuZnqiBj5A1m87Cy1N3n9oLcpLeeVhfqKQ9a/8hlwrSBYtlHHo3EHmIHE8Ep7A6aP5xuPRrUuvVzV5nArXI1+82zsjWRMSIYfXsh7llNOcOjg6jooBNJZFSKOVTcuKOcxkaE+5SFDgHjrySwhcPU6r0j7P6Rkd025olKe6wt1wYtPt2Ru1lXsfOpOSiaQNn5YDdIyh+fJNkV8zTEQ/sRQs1ftw33kgm813WNYBCcaDPRA+9dkzGMjL7uxpGQj5wmbomvKqPzPYVpzBIGxIX+dq3lpQUCmwOWpQbmsLTY1HlYzi3A7viQL2Gd96x/f0aNnoMQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UzBYq6RaY6NFYpTUVNHA245ENvUipVMb7aoWROfq4Sc=;
 b=BlddN/3XNGHazH0tfqs4MVWx0rkShzCX0Ju6cadOcPNdy8VJwq2JndTf7nQJtgQAm1HFXWff01+AxDvsq6s5Jkf5zo7e66F2VIZYErObCL3tEC71DdR+zLmqjXFtHkkkxVQOsLiL9zSG1YVbwwdHtFusMbVjl3Bz5f6bsMFOzjsx/Y8A4SuNNLXH61U5/WHSkekyw2N5yz3zaIX76goAARM9teS4Gv+oX9H5Y+e1kXa5+RWf/64L0p7LGc1BbIsMJTzXFfTT3BG/oWSBwzvK3OMRh7OU3G6sn6C1aq1CIkRDGGcY3SKbiLM4xsW6SzJjPnwyPPtrMzrkIT/OP0yPvQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzBYq6RaY6NFYpTUVNHA245ENvUipVMb7aoWROfq4Sc=;
 b=GwTS/nhq2bdat3sbhLVbgc4vnxvri1mqk/oee+WTwPhf8MnEctpd/4zb8EHK0waWF71W5PwsPepbAUKGgFkebLLtluafm4a7vH00M3c7CHxnqcdD2Tajt5bIEysAn5gE/zpAmUsZKvp+wx1qvzG/YOkzXdWHBqOG6Ios1I6mWJQ=
Received: from AS4P191CA0019.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d9::9)
 by AS8PR08MB9268.eurprd08.prod.outlook.com (2603:10a6:20b:5a4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 15:10:14 +0000
Received: from AM3PEPF0000A791.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d9:cafe::ae) by AS4P191CA0019.outlook.office365.com
 (2603:10a6:20b:5d9::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Tue,
 31 Mar 2026 15:10:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A791.mail.protection.outlook.com (10.167.16.120) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Tue, 31 Mar 2026 15:10:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QCFFwe3HicJxZIm8y7dGpQYnnw5qCO7OygVhwbJZSI7Q3omAtreAUWX2TIIyISVBEJHj7gX58fHcZ+9+gCAEWXJCgqub6WMhtYbOe/AkOqMzDx6/1jWb2JtgUchRk7JDPSbYfLU7gKYwNbcQjwsLcXv/+veLDEgrrjPCmIagQyYdYHxVheD9GH/B3XO5BpQV5QOJPHDubg6rvmQx6hP+XMcB+ri7SU87LXqtQEHIcLzg5lMOUTylrWY1dk+0therIYkA/vGn0bzBriW4UCRRK0o7JmwVDw1Jzqe4e6tKmTC5zmOcnHnu4K3v+tIdoYi+U1cHbqTYd17+LiSllUUdxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UzBYq6RaY6NFYpTUVNHA245ENvUipVMb7aoWROfq4Sc=;
 b=dfOBn//8ohHnHNFSIcJwJjfK/+GvOkCuw5FdDCqXb8034OZN+IqeA/5WkD4qv44BgvNIFmaqAn2rO8P3/ZMipvQxMB6A575YlMJdPYfOaYuyqCHCHznenbseoUJ9PB9FR9gYI5+ACgrpnariAO3lO3DZsNIScqizr2aaT+eakhcLAhH837+w+xI5UAmLto41HDl3wERrMQRVo1hiKP2v4H2fEaJSjYJD/P/00Z3Wv+tPUAfMQk974fCFdZ7qr/+lbqHg4qQfAOwIuJOWqgewGn6YgpIA1bSYwppcxnloCR7XCr/e+0UulGm7NKEBvSbj353NbgeLaNyuGytgdkJU9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzBYq6RaY6NFYpTUVNHA245ENvUipVMb7aoWROfq4Sc=;
 b=GwTS/nhq2bdat3sbhLVbgc4vnxvri1mqk/oee+WTwPhf8MnEctpd/4zb8EHK0waWF71W5PwsPepbAUKGgFkebLLtluafm4a7vH00M3c7CHxnqcdD2Tajt5bIEysAn5gE/zpAmUsZKvp+wx1qvzG/YOkzXdWHBqOG6Ios1I6mWJQ=
Received: from GVXPR08MB8233.eurprd08.prod.outlook.com (2603:10a6:150:3f::12)
 by DU0PR08MB8929.eurprd08.prod.outlook.com (2603:10a6:10:464::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 15:09:11 +0000
Received: from GVXPR08MB8233.eurprd08.prod.outlook.com
 ([fe80::af81:850a:9bd0:1182]) by GVXPR08MB8233.eurprd08.prod.outlook.com
 ([fe80::af81:850a:9bd0:1182%5]) with mapi id 15.20.9745.027; Tue, 31 Mar 2026
 15:09:11 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
CC: Joey Gouly <Joey.Gouly@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"oupton@kernel.org" <oupton@kernel.org>, "broonie@kernel.org"
	<broonie@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH 09/15] KVM: arm64: vgic-v5: align priority comparison with
 other GICs
Thread-Topic: [PATCH 09/15] KVM: arm64: vgic-v5: align priority comparison
 with other GICs
Thread-Index: AQHcvTY1cdajWVfb70W1MqZk1TpkF7XIxjmA
Date: Tue, 31 Mar 2026 15:09:10 +0000
Message-ID: <729851f0e7d277d308adf04d0008156a01f482bb.camel@arm.com>
References: <20260326153530.3981879-1-maz@kernel.org>
	 <20260326153530.3981879-10-maz@kernel.org>
In-Reply-To: <20260326153530.3981879-10-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GVXPR08MB8233:EE_|DU0PR08MB8929:EE_|AM3PEPF0000A791:EE_|AS8PR08MB9268:EE_
X-MS-Office365-Filtering-Correlation-Id: 13713937-ac3b-48fd-210d-08de8f379c82
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 M2KTXKYpv0CqEMS+PP8T3fBtSQQzX9wp565QeT/Bqlg4ZfY6TUfWYIe/E+d8SzMo/GX6KrJW6kOVD9ffF6f4DnHEJnHCAjW/xJ8FxWH+7o1G7o7fNXQQOpuLSp7egi3BsRk7rPgMmUAG2gDKygAUnie7cTFbBsbkcZ51m8Lr3kekdDYMDeWkGAvyUVaKATPnvldPa2UtHwpWwIl5A7xW2GH+jJ/7NK1YOKqJZ4ve1l0Ztu5sf05bpb0OjL+RWFxj6F6O+bhiCZj3kv9Kxx1+1PjoEdDRNXduK3Fr1xgwsbga0mN9Da3p5K7KGsiaavmufOd46o2zygioO/QJ4zsrdHIRlowFlFFnevEYLZ6K1OZcJnpKHLQto+Xa8mrVF9aQOcT8gK2csXVbOuKIJP/1YI+Ao2NhKZwsCbWeT9yWCIh/BeqGv54V7+J6v0F8nfLfASQTLgV+VLsMtlKXbKf004IT2DfKBVb+SQWgftb+1J5n/yIk2XlM9bLvr77NuFmy52Ws/AYS12tRZACh/xOY5dCHGmhPn70EdVzhWsN1YBqDM1MahlIdQTE6t9xEZDCUQOyBHsE29VONkgWSJ8u89CddBGdPlV1KssmVRCsMA3NHEE9X3ISSr8NdEAvn10/SFKjQvnUz0C5qBM4fFMyKSeLPhVz9OAHXR2yEaFiScE0GyOIWuzkQJI27IDg//mPXCofb7ZPzyJ1o/CvxkKUlAlCwi2K9QII6wuUr8BVxCqo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB8233.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <237E8D36490DC34F882F49A1762C7347@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 j98SOjWS3mcG8DpOVeZ71Kpw1xaO0DN6K4eQvkZNBvitT2bUNYpWYuBLgV/nk1sfnTNYoD0FIzUQunX5QTtNOe3JcHvikzdiLIgNIakrqxA7oj0SjLJSdoN08yxfuELZ06oI/YdfGHOZqUyHgutvm6h+Lo9kBpydIwUSMIIQ+dK/XiHEoTGSSmYMwQE1ZZyUYGU6+M4C6jIL9JdOMHxK42FIWVJoZzidwpb9qKViiO1AWUS269wccUAjvkEsP+1tFLicJOEbUD+2U6PSkpB7blNt5oKPweOfgzUzk5oNsrFWQax+6Nbo4iTIIMXc1rnu8TUYdLlJyo86Xx2oPuqt7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8929
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7dd7fd71-7f56-41a3-51c4-08de8f37769f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|35042699022|36860700016|14060799003|56012099003|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	UVyHmXl+rXkkHC+cp3T8lKUeQlI09SM2tX2PyHv1dYO4E5gpgs/QebhmPDdGCK9lEpIGZ/uUD81byhhBih5+J0o+nHaB1b1+jQfMUgygBzp+IzPW4/OdtwY4/CHpuuLoPlbHPXWdC9ybWAG/9jCVfYER9GyNzY4Wc5l0sx3h/SeqV971vRfaAyJZhvOwAeR5ikXeBjldGONzcA/OwxjsIfVW7qG16ywjENVKRpU5MJ0CyWRTlQWXjSk7PYwXznW9gctgaoCEzN+a+m57Ziy8DKw/DUPLtBIFttiXkqsf6n51oIz5n1f+NlyVOmUd6qmi5ghy7gB/sGzc+8ykhr3ZoPcC6NVxIKpw03O8GKTDQhTHiBeAesW4wnhLGyOaVKlnJAuw8X/62HiYVuddkdgG4FgfFwvmEtl5XcUL4guJghKTyaZHOS/bJWhrkqF1vXVr7DPneBRY/tGoyr09XHSaBkCc5qKAvbvCOUSp/Gzfhul/PddN3xUKr4qEFhKoFh2m/D26+XGYYYJ3CQePdbbcD7iCupB0XpVoXNTKqYvZvhP1nDj+TzL2DVHHzkKSR59mltTa7jKPnaG2yF9C55QpxlzgNn99HO14aTID2mlNXy0bZBjypRwk+Mkk2DN+EzQ6kFtfqNCG+PR4v4N90O06Lz2IU/Ql3C9drS4Tmfcu82wq1jI7JFntfxCkSnEfA9KNNC8UsFIH406Ay/c7Ar5k1Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(35042699022)(36860700016)(14060799003)(56012099003)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	msvUWGC+1J5uGsqaQ8IkQBQIQfjrjxokkAnAzEgSI8VyrosVjh2shH/RvfJvxE0v4ObqzKlXGNjtsR1ZHnbNkmbqf4J5P+MocfR/ua30MJbjB/ZLdbhE1s14jHCCLH/u++7Ir2rUEIjKNmA2tX2OPVx4KUP9nkCVIGgc7dKdaWF5F3y82B+Z9y4XToFw7XBOCL0TjeNbLmC3eyzlo7Y9A99HSDh3C2GRsP2tbLgdMdwoolKObASVS5r5lS2j5VTaVUMIM8D2VpkwezKRwNARr/83GUGBtCI3LGBhiW0xG6Fm0fgWMtiedX0OViwcXyo8XOfSEec9HHHs15FYkhscPcV/sj/4TkNmTOv+pdybyirkV7VsKbxudVdBWpHMjMiUPgqmKm8z7NTlb+/k4w+U7adlKB6xlxV44rq/G/SAsbLl5UKgUbKpWyqu9ny56M5M
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 15:10:14.3914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13713937-ac3b-48fd-210d-08de8f379c82
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9268

T24gVGh1LCAyMDI2LTAzLTI2IGF0IDE1OjM1ICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IFRoZSB3YXkgdGhlIGVmZmVjdGl2ZSBwcmlvcml0eSBtYXNrIGlzIGNvbXB1dGVkLCBhbmQgdGhl
biBjb21wYXJlZA0KPiB0byB0aGUgcHJpb3JpdHkgb2YgYW4gaW50ZXJydXB0IHRvIGRlY2lkZSB3
aGV0aGVyIHRvIHdha2UtdXAgb3Igbm90LA0KPiBpcyBzbGlnaHRseSBvZGQsIGFuZCBicmVha3Mg
YXQgdGhlIGxpbWl0cy4NCj4gDQo+IFRoaXMgY291bGQgcmVzdWx0IGluIHNwdXJpb3VzIHdha2Ut
dXBzIHRoYXQgYXJlIHVuZGVzaXJhYmxlLg0KPiANCj4gQWRvcHQgdGhlIEdJQ3ZbMjNdIGxvZ2lj
IGluc3RlYWQsIHdoaWNoIGNoZWNrcyB0aGF0IHRoZSBwcmlvcml0eQ0KPiB2YWx1ZQ0KPiBpcyBz
dHJpY3RseSBsb3dlciB0aGFuIHRoZSBtYXNrLg0KPiANCj4gRml4ZXM6IDkzM2U1Mjg4ZmE5NzEg
KCJLVk06IGFybTY0OiBnaWMtdjU6IENoZWNrIGZvciBwZW5kaW5nIFBQSXMiKQ0KPiBMaW5rOg0K
PiBodHRwczovL3Nhc2hpa28uZGV2LyMvcGF0Y2hzZXQvMjAyNjAzMTkxNTQ5MzcuMzYxOTUyMC0x
LXNhc2NoYS5iaXNjaG9mZiU0MGFybS5jb20NCj4gU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVy
IDxtYXpAa2VybmVsLm9yZz4NCj4gLS0tDQo+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1
LmMgfCA0ICsrLS0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5j
DQo+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gaW5kZXggMGYyNjkzMjFlY2U0
Yi4uNzUzNzJiYmZiNmE2YSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2lj
LXY1LmMNCj4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gQEAgLTIzOCw3
ICsyMzgsNyBAQCBzdGF0aWMgdTMyDQo+IHZnaWNfdjVfZ2V0X2VmZmVjdGl2ZV9wcmlvcml0eV9t
YXNrKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gwqAJICovDQo+IMKgCXByaW9yaXR5X21hc2sg
PSBGSUVMRF9HRVQoRkVBVF9HQ0lFX0lDSF9WTUNSX0VMMl9WUE1SLA0KPiBjcHVfaWYtPnZnaWNf
dm1jcik7DQo+IMKgDQo+IC0JcmV0dXJuIG1pbihoaWdoZXN0X2FwLCBwcmlvcml0eV9tYXNrICsg
MSk7DQo+ICsJcmV0dXJuIG1pbihoaWdoZXN0X2FwLCBwcmlvcml0eV9tYXNrKTsNCg0KSGkgTWFy
YywNCg0KVGhpcyBwYXJ0IG9mIHlvdXIgY2hhbmdlIChkcm9wcGluZyB0aGUgYC0gMWApIGlzIG5v
dCBjb3JyZWN0IGZvciBHSUN2NS4NClRoZSBHSUN2WzIzXSBQTVIgd29ya3MgZGlmZmVyZW50bHkg
dG8gdGhlIEdJQ3Y1IFBDUi4NCg0KRm9yIEdJQ3ZbMjNdIHRoZSBtYXNrIGlzIGV4Y2x1c2l2ZSwg
aS5lLiwgb25seSBoaWdoZXIgcHJpb3JpdHkgKGxvd2VyDQpudW1lcmljYWwgdmFsdWUpIGludGVy
cnVwdHMgYXJlIG9mIHN1ZmZpY2llbnQgcHJpb3JpdHkgdG8gYmUgc2lnbmFsbGVkLg0KDQpGb3Ig
R0lDdjUsIHRoZSBwcmlvcml0eSBvZiBhbiBpbnRlcnJ1cHQgY2FuIGJlIGVxdWFsIHRvIG9yIGhp
Z2hlciB0aGFuDQoobnVtZXJpY2FsbHkgbG93ZXIgdGhhbikgdGhlIG1hc2suIFNlZSBETVNRS0Yg
aW4gdGhlIEdJQ3Y1IHNwZWM6DQoNCkEgcGh5c2ljYWwgaW50ZXJydXB0IGhhcyBTdWZmaWNpZW50
IHByaW9yaXR5IHRvIGJlIHNpZ25hbGVkIHdoZW4gYWxsIG9mDQp0aGUgZm9sbG93aW5nIGFyZSB0
cnVlOg0KICAgKiBUaGUgcHJpb3JpdHkgb2YgdGhlIGludGVycnVwdCBpcyBoaWdoZXIgdGhhbiB0
aGUgcGh5c2ljYWwgcnVubmluZw0KICAgcHJpb3JpdHkgZm9yIHRoZSBQaHlzaWNhbCBJbnRlcnJ1
cHQgRG9tYWluLg0KICAgKiBUaGUgcHJpb3JpdHkgb2YgdGhlIGludGVycnVwdCBpcyBlcXVhbCB0
byBvciBoaWdoZXIgdGhhbiB0aGUNCiAgIFBoeXNpY2FsIFByaW9yaXR5IE1hc2sgZm9yIHRoZSBQ
aHlzaWNhbCBJbnRlcnJ1cHQgRG9tYWluLg0KICAgDQpUaGVyZWZvcmUsIHdlIHJlcXVpcmUgdGhp
cyBgKyAxYCBmb3IgdGhlIHByaW9yaXR5X21hc2sgaW4gb3JkZXIgdG8gYWxsb3cNCnVzIHRvIGNv
bWJpbmUgdGhlIGFjdGl2ZSBwcmlvcml0eSBhbmQgcHJpb3JpdHkgbWFzay4gRWxzZSwgdGhleSBv
cGVyYXRlIG9uDQpkaWZmZXJlbnQgc2NhbGVzLg0KDQpJJ2QgdHJpZWQgdG8gZXhwbGFpbiB0aGlz
IGluIGEgY29tbWVudCB0aGF0IGxpZXMganVzdCBvdXRzaWRlIHRoZSBkaWZmLA0KYnV0IGhhZG4n
dCBleHBsaWNpdGx5IGNhbGxlZCBvdXQgdGhhdCBHSUN2NSBvcGVyYXRlcyBkaWZmZXJlbnRseSB0
bw0KR0lDdlsyM10gaW4gdGhpcyByZWdhcmQuIEFwb2xvZ2llcy4NCiAgIA0KPiDCoH0NCj4gwqAN
Cj4gwqAvKg0KPiBAQCAtMzY3LDcgKzM2Nyw3IEBAIGJvb2wgdmdpY192NV9oYXNfcGVuZGluZ19w
cGkoc3RydWN0IGt2bV92Y3B1DQo+ICp2Y3B1KQ0KPiDCoA0KPiDCoAkJc2NvcGVkX2d1YXJkKHJh
d19zcGlubG9ja19pcnFzYXZlLCAmaXJxLT5pcnFfbG9jaykNCj4gwqAJCQloYXNfcGVuZGluZyA9
IChpcnEtPmVuYWJsZWQgJiYNCj4gaXJxX2lzX3BlbmRpbmcoaXJxKSAmJg0KPiAtCQkJCcKgwqDC
oMKgwqDCoCBpcnEtPnByaW9yaXR5IDw9DQo+IHByaW9yaXR5X21hc2spOw0KPiArCQkJCcKgwqDC
oMKgwqDCoCBpcnEtPnByaW9yaXR5IDwNCj4gcHJpb3JpdHlfbWFzayk7DQoNCkkgYWdyZWUgdGhh
dCB0aGlzIHdhcyB3cm9uZyBhbmQgc2hvdWxkIG5ldmVyIGhhdmUgaW5jbHVkZWQgdGhlDQplcXVh
bGl0eS4gVGhpcyB3YXMgZGVmaW5pdGVseSBhIGJ1ZyENCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4g
wqANCj4gwqAJCXZnaWNfcHV0X2lycSh2Y3B1LT5rdm0sIGlycSk7DQo+IMKgDQoNCg==
