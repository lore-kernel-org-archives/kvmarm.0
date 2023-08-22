Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2074.outbound.protection.outlook.com [40.107.21.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEEE8464
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 15:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfrtkIHD41BdedViPMyVzl+Hx3DX+Q5alc3k43j05cI=;
 b=KNOT4WQr2ip1eJmqTzufkPODbARBuwPqAGEyg6jwpkUvQuj4hpohkJYoQs4aBWGNs+kCbeSXxznfj+zGXGBCf8g7HLr3Enjotltdm9WrXEcSlyi/WfjklvG65BbEF8OcU8vJTeatsxO/PJ4bBqUjSnqV6qdc+zHyL2aebdW5uTM=
Received: from DUZPR01CA0087.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::18) by DBAPR08MB5637.eurprd08.prod.outlook.com
 (2603:10a6:10:1b0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Tue, 22 Aug
 2023 15:05:49 +0000
Received: from DBAEUR03FT051.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:46a:cafe::ec) by DUZPR01CA0087.outlook.office365.com
 (2603:10a6:10:46a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.20 via Frontend
 Transport; Tue, 22 Aug 2023 15:05:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT051.mail.protection.outlook.com (100.127.142.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6723.15 via Frontend Transport; Tue, 22 Aug 2023 15:05:49 +0000
Received: ("Tessian outbound 169aaa6bf2b7:v175"); Tue, 22 Aug 2023 15:05:49 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: d37bb38f735fa9d8
X-CR-MTA-TID: 64aa7808
Received: from 44561ca60c7c.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 31AF0FB9-91C9-4605-8271-7B75269EFF6E.1;
	Tue, 22 Aug 2023 15:05:42 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 44561ca60c7c.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 22 Aug 2023 15:05:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLmSz49N4qNR5r0qm1oDSblwsc8ngBADluagQFCnQzg6tDu95KIShybBbukcLSpFGdJK+2kOsRVTFLOgSYqqzl0/gUxCEaG0Fpl2X5UShTkYZs30CnrvrV/elyUWl5QUhAi5XvE/ONduBFMRg3bpv5Zpj6lU5pb6D7qecDNUsa/RZuutI4kK6I3mlnJxqXjc7IlN/hKYdMLt0yESjnr1OvuHI9JSHb0Xak+FQUMr+qrL3he5uFk3JMp7jvDOdi9x+xceVRBSBqRdjpYIu/+eGowkzlXgtnAgxk+l5Xo/XLey+RcNN7NNFk8EdEjYO7wsH8sQsP08pOlgqIsl5GPWFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfrtkIHD41BdedViPMyVzl+Hx3DX+Q5alc3k43j05cI=;
 b=Ok8nPlgNTEmmtAwEG3R3clvatLK6DtXq5BTK43DZIYItmOAvdWWx1NuhwB/d5q1X8mv75I+2rwPKjF5qFuXqTdGiXYYnKvImc3kYeomlPznbW46YFDUCoWnOEth+x48Gb1d508XXW3+5dqfjExWnIdbUGGdvERB5lBaxFq10gxSuNRwu7gpDFCNmI9sLICYDUwHEWTdllKjQbIAh2UEwxHY6idVbEswpF2h8LVByveNYaoCUXIWssFzMY0DbPtxIvFXS7h9rYZ1+XPpJWkPiugiuJw04Hym8pllNokQmX4iMO26VMXI93/vN6NLU8NcfMYi9wMz7zVkAuJvruN4b2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfrtkIHD41BdedViPMyVzl+Hx3DX+Q5alc3k43j05cI=;
 b=KNOT4WQr2ip1eJmqTzufkPODbARBuwPqAGEyg6jwpkUvQuj4hpohkJYoQs4aBWGNs+kCbeSXxznfj+zGXGBCf8g7HLr3Enjotltdm9WrXEcSlyi/WfjklvG65BbEF8OcU8vJTeatsxO/PJ4bBqUjSnqV6qdc+zHyL2aebdW5uTM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Tue, 22 Aug
 2023 15:05:39 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::adb0:61cb:8733:6db2]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::adb0:61cb:8733:6db2%7]) with mapi id 15.20.6699.022; Tue, 22 Aug 2023
 15:05:39 +0000
Date: Tue, 22 Aug 2023 16:05:15 +0100
From: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
To: Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Arnd Bergmann <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>,
	"Rick P. Edgecombe" <rick.p.edgecombe@intel.com>,
	Deepak Gupta <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: "H.J. Lu" <hjl.tools@gmail.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH v5 04/37] arm64/gcs: Document the ABI for Guarded Control
 Stacks
Message-ID: <ZOTOqxBFqselqN8U@arm.com>
References: <20230822-arm64-gcs-v5-0-9ef181dd6324@kernel.org>
 <20230822-arm64-gcs-v5-4-9ef181dd6324@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230822-arm64-gcs-v5-4-9ef181dd6324@kernel.org>
X-ClientProxiedBy: SN1PR12CA0070.namprd12.prod.outlook.com
 (2603:10b6:802:20::41) To DB9PR08MB7179.eurprd08.prod.outlook.com
 (2603:10a6:10:2cc::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DB9PR08MB7179:EE_|AM8PR08MB5732:EE_|DBAEUR03FT051:EE_|DBAPR08MB5637:EE_
X-MS-Office365-Filtering-Correlation-Id: b75988c3-b771-44ed-4b0a-08dba321455a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 YcQqMwk4Dn5hMK+j4004Cs80OkhHHW6XQ7wOn41UvxizXAzqHevZO8vajBB9wd6zzuuO/XQSS10lQO09TMQVDfSDBHBMpeq2o9AcXLqwGMhvEe259I03oqU8PCZLDkXX7/q5VmGxHru6Ld/j3nQdfeSuVbb0v/VTe4Oel4cmS6F+InXhLkK/b7NTmpC8KttkbWlKmZqw2oVUOsEEqCrrtQEidefpZtXNy9KIpjRUeqSvWgHBPTG5Gi6fTShgUV9cDG9/fcX48UQWgPQEKZx4cw3Xm4STZn3TeyCdClt+bArIyIJjvq2HvPUugHEITSgPWmv4xqWU//JPcnpFnImaZkWXRUcM8HVs8sbB4DyljPhGEq2up1Q6LH+2jaWwxQ2WMp0gl9YjzDNvbOG8LmC1P+CSbh9Qcc7eJ1m3Eozz9YA34eQ3RIhTLhzbrwj8KQ5NBQSGflJATJtHpcqvxZE0j2J0Giy3lpuIkx/KGdBXOPWWhqaJXm6IYDh3OhS3lNHR+R90aZLBTTfQqmmMKnvBjSFYJbV/kf9nv7lPuPWQ1ET3jxTMhDbfJXF8/T8g/2buoK3RXkbc81lJdh/FBpyIgpbsuuRHu/CPZzRpVKK6CwQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB7179.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(39860400002)(346002)(366004)(1800799009)(186009)(451199024)(54906003)(66476007)(66556008)(6512007)(316002)(66946007)(110136005)(8676002)(8936002)(2616005)(4326008)(36756003)(41300700001)(921005)(478600001)(6666004)(38100700002)(6486002)(6506007)(4744005)(2906002)(7416002)(86362001)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5732
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DBAEUR03FT051.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d3ed07dc-d070-4514-981c-08dba3213f11
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	idhXpcC3kp4vXp5KYiWx1OLYz477PEA97BwBmhZqFhMiVeikQlV1nmbRG3GGk5TvoNiviV7aEwWwDG+41vVb26Fzvxe2y8DPA3OFVZ1aWorV0CG5gZQjMVFgi3g33N58aJEhAtkYyu6qXuiYNYY4hVofpkjh8aRi+BZJ1to1fOVvv2UR1bGVPNvszn2OQ9HTg5pVJTMrMRfVrtrtj8ey2bIPc+cNmDCe/Rhk6upx+sBpnbHTs0BXdsQeDFFKKu1TSgF/8MXt2yxBD0rqo3oL6q1QNM/+HUyK8JTmzQ+GgBjAAJLPNJMzmbxwNOO8TGFewnrfauxp3x8fSq2iy6Q32SDCz29ia5uxNz3MbImYfd3a4ZShwOrEQeCZQv0FHxmOMEcL8WP3iT5JPmbrQhEF3Rdv+J5nO42fVLH+2atknbRD6Qt0mUPwLPCYxadCJ8bGSajgTmXL9qmfx4VBkRexQSQtGx3MnJkLF8sntF8Q5JshbtiP7GQf7LhG+eiVFa+hRcX+zS9N5hYBYRotGJOOEOay3bkEV3xsNqXcPf2Y1bSnh7+O2zprcwdhXV/aOBDUZz8fekKSFK5WBU/UTLfcDXTy0fFHkN4ffsmlqZ12r1eqowyfFObZUND6TadgwCCwvF1sfAozihOVaPW2PmL5K8UY3o28M2uRLvEhk8jJhNbEFFMY0ItfzOgdiHN8ginbq27d7Nj8tiqKjjuSfSroDw6gYLrkejJdXjXD4mcBIyUID24WxbSAQMUM8vWKWgK3
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(39850400004)(136003)(376002)(346002)(1800799009)(186009)(451199024)(82310400011)(46966006)(36840700001)(40470700004)(54906003)(6512007)(70586007)(316002)(70206006)(110136005)(8676002)(8936002)(2616005)(107886003)(4326008)(36756003)(40460700003)(41300700001)(82740400003)(356005)(81166007)(921005)(478600001)(6666004)(6486002)(6506007)(40480700001)(4744005)(2906002)(47076005)(36860700001)(86362001)(336012)(5660300002)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2023 15:05:49.5694
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b75988c3-b771-44ed-4b0a-08dba321455a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DBAEUR03FT051.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5637

just nits.

The 08/22/2023 14:56, Mark Brown wrote:
> +3.  Allocation of Guarded Control Stacks
> +----------------------------------------
...
> +* Stacks allocated using map_shadow_stack() must be larger than 8 bytes and
> +  must be 8 bytes aligned.

"the size must be multiple of 8 bytes."

> +
> +* An address can be specified to map_shadow_stack(), if one is provided then
> +  it must be aligned to a page boundary.
...
> +5.  Signal return
> +-----------------
...
> +
> +7.  ptrace extensions
> +---------------------

section 6. is missing
