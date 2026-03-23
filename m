Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011030.outbound.protection.outlook.com [40.107.130.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89FF37E2E6;
	Mon, 23 Mar 2026 10:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.30
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774261933; cv=fail; b=RltF4IaWiqMIuaQZVbndpf/cJ3g0vRGbirFHeWbDAUNSG529b1PNkOKSMysKQ1cGSAr/OkfQuXnUTVpAGfV7ndGaMDX+lFD0OQlO1OzkSITWz4OIjupi6K1LfhyKr+C54B0QFW1CKLFt1MF+X7nkjWWxERaPgS2JaehtaG2JtVE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774261933; c=relaxed/simple;
	bh=Hz7XySnLzyckSqEFPT9TOsMuP7IW2O8uiIju6PeoKbo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=io9XzB2c7GJ/Rvuus6LbVZP2L4Mgkd62ZnU0bY7H1gEeK+YU+x/v+gU59saTFW0oNIgvdSu7F3Oe8hH7BVoYFUUJS1K6rMgNCAypU4sZlMCF9nMwXiYfWJDsdzvIP1kqQTTgfxzkYn2+paix8M9kll+etw9zto6lPra2Yz3KMrg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SA5iq5/g; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SA5iq5/g; arc=fail smtp.client-ip=40.107.130.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SA5iq5/g";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SA5iq5/g"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=oFFuvpXfviCesN49+g0H6ZFceKJIzdJdAeuI0N/Znub1iCBbkKOQL6Vdq2GQO2+uzU5LO1JlVTAoEAnoLs6B1YggiFYXELfIY1lCE1qDStIIbNKXc5a97or0WElzQnAUFIzBQOKsmTVOTBYh35ISWpsN/xg9FWUio6jPhLQCQlQsLTY119jodUx9Yq63skZtjfhc9cB5gHLaK4Lwhi19aBQCjvrDA0jgxXa1kOil8gGqTu1TOlFOGHEP0gfeUZa3chGFObAe0cQfGmxi9GLaB4A5qb94/+vLiW5iZaUFWhRpG4zIGj21L42Bgl1MLwfdm+vpVwl1Af+VU8Fl0p4fFA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3mXSrs8MmQs1gYiiLcB2aTrQdOkm1V3Pbf3jAnZO7s8=;
 b=QdhuCAIiabaz60JM0bi7eTZ8i25XAFIZ/2p+SRgtHU2aG4LiH0rDp7oSd2My/kTXqz2LvUjhJuOU0CY0RpiWyfbhBInnBY5vulLSHi3NfpZ3jlQrn0jLYNEx+pb8vQV1yOJWBpIKjD4nJp9h9TuBWf9vaDvY076FCxzfNlOIBQVhtaXix2m5PaXFIcSR9jL7CrOwfxoWHlPToJg98n6EbyHfloDVRC9TUrP/bU5fBYiKFJ7RK1qor+3+chweOktK65bq1jV7gA0n1nFKD+/E4oeGcEwYFJrvwPcSXIY/s+ZQltORtJQFYMGact353qhtqfw0twxUBFem5Tb5sLbC8A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3mXSrs8MmQs1gYiiLcB2aTrQdOkm1V3Pbf3jAnZO7s8=;
 b=SA5iq5/gXCHxf5yXVPsx3HpdcbS1iD5Odvtr1kqhCGYc8QXuF25GWWIOFmsddEv2P2sa6uj2Vc7Z1aoioZNFJs7lY4qJQoy/254cN51wwpv8O8KHnUlz5UbWHEm0iujEQ3H9GYcwWZEWPC7KMXpq6clNa1st3nSWhFTQMeSuT3Q=
Received: from AM0PR02CA0140.eurprd02.prod.outlook.com (2603:10a6:20b:28d::7)
 by AS8PR08MB8491.eurprd08.prod.outlook.com (2603:10a6:20b:566::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.25; Mon, 23 Mar
 2026 10:31:57 +0000
Received: from AMS1EPF00000092.eurprd05.prod.outlook.com
 (2603:10a6:20b:28d:cafe::89) by AM0PR02CA0140.outlook.office365.com
 (2603:10a6:20b:28d::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.25 via Frontend Transport; Mon,
 23 Mar 2026 10:31:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000092.mail.protection.outlook.com (10.167.242.89) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Mon, 23 Mar 2026 10:31:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pen4J0it8NinD5Anr3TDQF2ET9xSvbKvovTKeLdCApo2u9j95u9SMsXXUAirGi4N9hYGvn7c5KXnH/pFsNcYx7PZI3VSlsJaAvuSqEMruhjxY8A7Zm2rztT4EdEs5gr+laComX5GG4aA1YBKYxuPoJ54B+cYjg5I63iKKapn9Qn7tlUfObA3lvbqlEXxMuViUjMCy4ibO0mQ7fjOV4mhO7K/nZGv+7Eqjj51ERWEEZ4wI2PNh5kBYCubYTl+2Al/1Ll9ntRjRwYBfYfBztn3rD4XJ/PRJ5hALQC7GOF/T8+VzpIC5PTcuIYtEKnGusEzawFBZcZX11wgC6tv88BLYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3mXSrs8MmQs1gYiiLcB2aTrQdOkm1V3Pbf3jAnZO7s8=;
 b=fRQlk5AcbbnGJRCXhowja7GabYSgAEqiWJPHfNNPiqh3xFRvEIkP0WriVisIOuCxnlIlHqwXJSGVr/ue62Zvffvb0wmkFrYlx6XNCyghl96CYgEkui8GkKJm42aRp/CX7lM/k7/3cI4k9CgCnLurZLhaGmhlZcRFG07H1YraY2iG/GnC/2JUXAkJkbvF2i1hXDcwU/gs4x2E4AjZ+mz6X20DU2CN8Xfg98HnuEZ6GL6TaUsLMTfjCRd1KC0ov3fawvQyJugc6AgLP+fvz5a/N6KUqQXpVhLw76RWF31+m30+u21WVy6BojLOTfLH3xaa8SEaJC2zVIB4yINTSm2o8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3mXSrs8MmQs1gYiiLcB2aTrQdOkm1V3Pbf3jAnZO7s8=;
 b=SA5iq5/gXCHxf5yXVPsx3HpdcbS1iD5Odvtr1kqhCGYc8QXuF25GWWIOFmsddEv2P2sa6uj2Vc7Z1aoioZNFJs7lY4qJQoy/254cN51wwpv8O8KHnUlz5UbWHEm0iujEQ3H9GYcwWZEWPC7KMXpq6clNa1st3nSWhFTQMeSuT3Q=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by DB9PR08MB11895.eurprd08.prod.outlook.com (2603:10a6:10:614::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 10:30:55 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%5]) with mapi id 15.20.9723.022; Mon, 23 Mar 2026
 10:30:54 +0000
Message-ID: <b6fc1b86-925e-4469-9255-c8398f3a305a@arm.com>
Date: Mon, 23 Mar 2026 10:30:54 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 05/48] arm64: RMI: Temporarily add SMCs from RMM v1.0
 spec
To: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-6-steven.price@arm.com> <87cy0xco7f.wl-maz@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <87cy0xco7f.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0375.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::20) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|DB9PR08MB11895:EE_|AMS1EPF00000092:EE_|AS8PR08MB8491:EE_
X-MS-Office365-Filtering-Correlation-Id: 55bd5a21-12f1-4c0c-650c-08de88c768b1
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 JcSsOIVeKflMUQEy881Q5xSb7pi3d6TBcRGyE0Yc/anRDLxRSAdozKVCtGGX75yUdu71eIaWeh8SPh5VxA2fHbrQZ8lD/XgfA+hapBgBeCi60UuxoHytCdjrmAo+9S/SrjwE7jMe6eNpKZbXsy6E5xYHB6eTlxAZbTsPrpzosaXaPRzvhA53tA2yRbkpz6e+CjGgoGFBx6f9YdYWGDzIR59fXJv9/tCrYm0xvBmFRphir212otHhuhuM9NpV7fQ6l6dsF74nwjo3cVqxc5YwCuKwgdTwFMw4wbBv1hHiUTrvSJfwKthgiL82Jq4RD6ACVd00xjSne0UUnLe/foJFxtAyR+iy9yFtzL2QtzuYqGdp/60KfLjyd5JNuI66kCUb7VYS4Bm6DlXiCTzjGrmlLvhemZZgB+8Iicb51oqtb4a7ZGqlJKcOCzPyyvnRVkjU1aKpHdqptnwCGc1KMtAbcInqnUdZx+QDLm2PD2SIyPiOLO/EdwOhdDcw3c6UlJOp8TyhMQjnw82RrL8B19kguLUzop7CUyQXvDoycKVsqX9IwJBt+VlgOSMeYi6xo3EZRqnz1IfARCDPIuZ3uR7P2gSPCpSGaZXoJexWDffd9X4VBCVLyF8Eek9ls189/58P6z++CB59DOT+odYkhvjvEgtfu2vf9vth1rKVJSIfWbo14KzEZBEYCln0LA2nyv+AOEx/iuEPE0CvX1KHBKy/WG8XwmlbEleoOQXikb0PYmw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 dADoh92GsF+UOcmN/HyohHuja7f2+M08qrmm6fUlTgN88UOjEqW6hiOWyiLl8EhWwLGONK1eVwkPDvCerXg6UtXCmq/l/wVjElIGM3Bv2mES+k+WHl38eNc1h6eqOjio9tIK4V/Rpu0GNIzbeNWBpH6nxmfzIIPLt2xfvGJSYQkH3uzpvEVUGhm4bI/gudNTDYYOw/0Vwt1EaKbR26ZSK9vhPLPUcTdG9w6HOveVypbTnO8iSRPfPsE21dft+jYoacXfjh6XHbKz+FlbJGKxN/hwLR1EwbG7DGAApyhUONDhk0qSCOj/RBrw+5hWm6X0iPxfzsIyZLWknGyqtZOmQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11895
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000092.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	36eb6492-148e-42f5-be80-08de88c743a2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|35042699022|7416014|376014|82310400026|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0UuC8H99ziZZx3HmCJSTqWFxbz2iPNfmQDFxbybLZGkZtvZwh8A1pMK+OTYuWJvsTppwCa9dQt5Gt90CpXFS+xeFV2L62UFKZMGlVvVBoZ8kFW5Rs49M40SVtQI/WvCcYpUYqSKgSp5CDseKKmQyymf3+nl3TsYgt8JEY4b5KhPqOIjhD1ck85sdQwb4R25SIk53dhLuRf6lVkd5XEF2ZW74DxyFLclRrV4IDXUCycscfwNE8tWS2TJ7A3ohSKr0AShfG9jj2ewvd4JdpTFSFXoDsl2Nthwfg0hb4Y/2Fi6neQhnj3FD769sGqkZ44pbCDI9zqk00ly+tlYs+UfFAQ5X2zJSBiCeu8q3DrZbyMLbT5cS1RW8vtHoTVA1L1SNdKsjMPrfvfesLvb4ptOLZzB+glMRj9QbJSVyzgS8Bb56+mPquH8f5ExVqY/iucr8MPdCXC5+8AsVjLNA59rYTlx3RaFNdq/MKUVAVcMZeFlm2gT3owPYIKS/gqbICVjpW5Wdt9doAzSbrje4gv/Iu8vlAWO5PNS3+QWqmJ8zR4FV9jXKJh9QZG7CJ9fmIJWUp14t28ZM4c6e+KuZ+0t8YIWCd/5QsUn+uiXjDgGLw2DnihJm0qNagWrIPBQYlD6u/B46mH1ZhVhJa9gHBYCe49318aoeL9UZ/r5IXudrm5YaMQKy2zQiA8Vv9I/bINUtRE5nXXYtbmafzLv9TWpiH9/xnFtvfUxSmd8AArg7xrx0P8MffyAghw7TVmi1ABW2BOgPhc4BAK+wjNy1UIBTlw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(35042699022)(7416014)(376014)(82310400026)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	AGozfq/PL4c5Tn7/tEr+K+BWv9vPatuZ5ByHOAyo0ANuvpn0t70k1WVfH3uZGbjsu9N3Yz6lfVNLiK0d1myGY91Lf26xRZXK6T8YNXLd3huLIa9fSnPmdcrQrmfBlNYgFlJmFjtmLsKash8hM2YzXj6pwUi1hG2Qx/JQwZ+e30oDbW4/fYYaPCW+j6AToipMpEcbrDHlAMlO8w4SiUp+c2jdBnFVeJ4rbXfyRvZr22OpvpieCOlWeurvX3aEAFTybLDqQgmffbpcodz9PWJPLvsZ/MZaB49z7KF/0vD07tGj2Y+vfW3jcmRhvOOTarRIDT9GVd5QSTyigJOQBJO+cV9VKAhsmqTNQmKTtsF9e3fznThTrnBmrXr+wYd6Tu+XdH8oYz/ObS9y8BxB4ubVsF9N5v6XDKoK+Ggx78PFxSSPHilZON4X7PPpZXM03g6E
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 10:31:56.8468
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55bd5a21-12f1-4c0c-650c-08de88c768b1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000092.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8491

Hi Marc,

On 21/03/2026 13:21, Marc Zyngier wrote:
> On Wed, 18 Mar 2026 15:53:29 +0000,
> Steven Price <steven.price@arm.com> wrote:
>>
>> Not all the functionality has been migrated to the v2.0 specification,
>> so for now we still rely on some v1.0 SMCs. This mixture is not
>> spec-compliant, but is necessary until an updated RMM is available.
>>
> 
> This sort of things really makes it awkward to review the series.

I agree, that this makes it painful to review as it doesn't get you a
clear picture of what will stay or what will change and is not the best
use of the precious time of the Maintainers. We will make sure to flag
the appropriate portions in the next iteration. Apologies!

> 
> Do you really expect the reviewers to mentally triage what is current
> and what is only throwaway code? I want to see patches that are merge
> candidates, not patches that are only there to cope with the broken
> state of the RMM.

Agree, we could clearly mark the "areas" of code that we anticipate to
change and by the next posting this will be clearly marked.


> If extra hacks are required to work with the current Franken-RMM, keep
> them as a separate series that doesn't pollute what is targeted at
> upstream.

In fact there are only a few areas that would change with a true RMM-
v2.0 spec compliant firmware. But yes, I acknowledge that feedback from
the maintainers would be fedback to the RMM spec and this might trigger
minor changes to align with them.

> 
> It also means that any testing you have done will be invalidated when
> the one true RMM shows up...

Agreed,  True, but not very much of the functionality/
spec are changing until we land in fully compliant 2.0 RMM.
See more on this below.

> 
> "This is great."
> 
> 	M.


> diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
> index 8a42b83218f8..049d71470486 100644
> --- a/arch/arm64/include/asm/rmi_smc.h
> +++ b/arch/arm64/include/asm/rmi_smc.h
> @@ -30,14 +30,15 @@
>  #define SMC_RMI_REC_ENTER			SMC_RMI_CALL(0x015c)
>  #define SMC_RMI_RTT_CREATE			SMC_RMI_CALL(0x015d)
>  #define SMC_RMI_RTT_DESTROY			SMC_RMI_CALL(0x015e)


> +#define SMC_RMI_RTT_MAP_UNPROTECTED		SMC_RMI_CALL(0x015f) //
>  
>  #define SMC_RMI_RTT_READ_ENTRY			SMC_RMI_CALL(0x0161)
> -
> +#define SMC_RMI_RTT_UNMAP_UNPROTECTED		SMC_RMI_CALL(0x0162) //


The above two RMI commands help with mapping/unmapping Unprotected
memory and will be replaced with two renamed commands with "Range based"
ABI => SMC_RMI_RTT_UNPROT_{MAP,UNMAP}. So, as far as the KVM code is
concerned, we do the mapping a granule at a time (without hugetlb
support) and this is simply a change in the command in the true 2.0 RMM.



>  #define SMC_RMI_RTT_DEV_VALIDATE		SMC_RMI_CALL(0x0163)
>  #define SMC_RMI_PSCI_COMPLETE			SMC_RMI_CALL(0x0164)
>  #define SMC_RMI_FEATURES			SMC_RMI_CALL(0x0165)
>  #define SMC_RMI_RTT_FOLD			SMC_RMI_CALL(0x0166)
> -
> +#define SMC_RMI_REC_AUX_COUNT			SMC_RMI_CALL(0x0167) //

This is part of the REC creation, where we donate AUXilliary granules 
for the VCPU to save state. This is replaced by the SRO method, which we 
have a WIP path at the top of the series and it will be cleaned up in
the next version.

We wanted to send this version out which is the first one with RMM-v2.0
spec, which has addressed the concerns and feedback around the RMM-v1.0
spec. But we have clearly felt short of marking "what is volatile" and 
what is stable, to help the review. We will address this in the next 
iteration.

Thanks for taking the time to respond.

Kind regards
Suzuki
