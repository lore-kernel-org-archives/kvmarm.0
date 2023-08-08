Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2040.outbound.protection.outlook.com [40.107.14.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BF7E569
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 10:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UE5kPNIMlO4tcZ4nCWzcUYTT04UQF69YFkcWGymoffY=;
 b=cw6GYSFjV2cbwC9Apj0Lx0DyfNq9stmyh259w3IoSM3ItTNiw/QxIFXbE/X+RtemITZeaKjiiiVJgn/h2nF9/5xzunGqX8mOTDNjFckztylCXXQz4323AiOQ9H74kvgKnyU3iCGqYebQGYwWAHYUEf6+kDkkeOhn7+WdAPftMaM=
Received: from AM6P193CA0122.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::27)
 by AS8PR08MB10361.eurprd08.prod.outlook.com (2603:10a6:20b:56d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Tue, 8 Aug
 2023 10:27:47 +0000
Received: from AM7EUR03FT003.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:85:cafe::5c) by AM6P193CA0122.outlook.office365.com
 (2603:10a6:209:85::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27 via Frontend
 Transport; Tue, 8 Aug 2023 10:27:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT003.mail.protection.outlook.com (100.127.140.227) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.16 via Frontend Transport; Tue, 8 Aug 2023 10:27:45 +0000
Received: ("Tessian outbound 997ae1cc9f47:v145"); Tue, 08 Aug 2023 10:27:45 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 1f1ba2880768a8a7
X-CR-MTA-TID: 64aa7808
Received: from ac7166f9e101.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 8898ABC7-85A1-4579-8BB4-BB77337FCF53.1;
	Tue, 08 Aug 2023 10:27:34 +0000
Received: from EUR03-AM7-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ac7166f9e101.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 08 Aug 2023 10:27:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsemYnMKlTdajE97yZpVtiHGovEaRuF6z/BOMUHkeg1nIEBf45gp7He5utI5N8cJ4EFPRt5dALNO1R5JpO1XBXMOgaom4YfcaKCOcv50H+sLMTmuUfGeQ7Ntif4rj/1TePlNs+J0LNS7hbfjxAZExE+mj1raXvakjCJa9M1hX4IHBIpwBo4KEeEn9xrxOtMozf9MvTwJtZmtSfYXk6B5Rm9eKrMslwObE5hy2YVgf6nS161pgwLASCoEoDprfZhebIa8f8H6lMZX/TkUvpKSiwJZHlvEm+1SdiV+S84brIuItTBpvA5G65qgKyV6UcoS5LHJ6jkvgXhjtXLVHEe7lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UE5kPNIMlO4tcZ4nCWzcUYTT04UQF69YFkcWGymoffY=;
 b=HM8HI7gP+xw5gj2zv7iNNiuSn4crolZjxTLpjlTGq73gb4lqCd88Pg4XQ/qnLGAibwlYiR2FlO1TY0SSsBjaFdtt+cCx6AzM9Y3Th1HA0KgtJvDVpUB6TeQTquTfueXSGbG6t7QV7oJtCVmlG2ydR1c7cRjO/kUGb9jbyFoiFI4XESpO0OT6Qab1Yq10SP3yCljoeRpF95Xkbf6rQVszwcRCrP0HTce1NdLOV9HpSL95GubO2nN5a6zrY2BQsiYArbVRRPlWTWuR3i7Wxa5A/jY6CN1eexhjBwtbiRwuzM681+WS5OJ7lhkO12jnpSifdH2ZobMvMRIXdCQLew6Bug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UE5kPNIMlO4tcZ4nCWzcUYTT04UQF69YFkcWGymoffY=;
 b=cw6GYSFjV2cbwC9Apj0Lx0DyfNq9stmyh259w3IoSM3ItTNiw/QxIFXbE/X+RtemITZeaKjiiiVJgn/h2nF9/5xzunGqX8mOTDNjFckztylCXXQz4323AiOQ9H74kvgKnyU3iCGqYebQGYwWAHYUEf6+kDkkeOhn7+WdAPftMaM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by PAWPR08MB9688.eurprd08.prod.outlook.com (2603:10a6:102:2ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Tue, 8 Aug
 2023 10:27:31 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::adb0:61cb:8733:6db2]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::adb0:61cb:8733:6db2%7]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 10:27:31 +0000
Date: Tue, 8 Aug 2023 11:27:16 +0100
From: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
To: Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Arnd Bergmann <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>,
	"Rick P. Edgecombe" <rick.p.edgecombe@intel.com>,
	Deepak Gupta <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>,
	"H.J. Lu" <hjl.tools@gmail.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH v3 00/36] arm64/gcs: Provide support for GCS in userspace
Message-ID: <ZNIYhC8L97J4B3KA@arm.com>
References: <20230731-arm64-gcs-v3-0-cddf9f980d98@kernel.org>
 <20230801141319.GC26253@willie-the-truck>
 <09b7a94d-cc88-4372-85de-52db26bc2daf@sirena.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <09b7a94d-cc88-4372-85de-52db26bc2daf@sirena.org.uk>
X-ClientProxiedBy: LO4P123CA0689.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::14) To DB9PR08MB7179.eurprd08.prod.outlook.com
 (2603:10a6:10:2cc::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DB9PR08MB7179:EE_|PAWPR08MB9688:EE_|AM7EUR03FT003:EE_|AS8PR08MB10361:EE_
X-MS-Office365-Filtering-Correlation-Id: ad3a035f-ec4d-44c7-f4ce-08db97fa1b3c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 9cLDC1fUdsJEOGiuPVBjxW2Q1857Uegdfr0Jm2ggFbE+jiifRedqBudePRSxqsB4XQ6GHpP8h3OuK40TyQKga5Rud2k0nGu/WLA56N9jDUM9kisrWMxh1PG9bvysG7Ux313pexYzM3yq8Ofx7yi+Yr6TGnWqqWfDt/R9Qj0laqC93TW18GEQ6GnMHEg7Gl8KLHDn8wPLz+K+uZ3xYaLoO8bJ48r2UTVMiDM3RQRhqpOOgbnkHkk4xNgbjdfHGDLtkSTeGFpkgMM6fUP6WpxFX9palb31LAlcJe009WsnAQoCJXs3fcXcckW6kL60ENSUbaaExSxXfTvd4nQGNgJEP8YXejtm2PHkbPvhbZXxEBPRyf58nhfw3m5XsAkYS+EXG/Na3YvpShP84kVHap8aac9MOiHV0TyxbDEZYGJhU1CkZMgCWneqdfMQHrK9PLYR9uPiBoJ94im9gZW+4IoKETNmxegyNkoxCxDiR++HojFOrYZIe9rG807GboXk2EijNCJAACtdV8Q5QJT49KfUqGHxJq+BHYHlfQTOt+3l11NmsJzGKJpaGZ+DcGMkQIlD
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB7179.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(376002)(39860400002)(396003)(186006)(1800799003)(451199021)(2616005)(36756003)(6506007)(26005)(6486002)(6512007)(6666004)(478600001)(54906003)(38100700002)(110136005)(66946007)(66476007)(66556008)(4326008)(316002)(41300700001)(8936002)(8676002)(5660300002)(7416002)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9688
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT003.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	904beafb-c8f7-4eb8-9f6c-08db97fa124a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	k6Mxki7mFiv2cwMxYhYjXcwMsmgMEVPDoSfH6oKLMlt8nqJtLOzzo/XdS7uRPFul1iGkDar/wR2VcNxgfED+hvFvqgVPqfyLxpcx7D0JFJFP/ULNAbVz+Jt2BsJTsmJKMMpCQxNOAHfMSX5Wb9fNtfMqYhLMsqs47xWUmO3qa0sRJLh/qrPNcc65eRum3XpC3SQzG6mXg1uoUyOgd7maCFRDeRkdbNpcJeJed/pxyVKjyTvi0caxo6zVJsCZgnt2JHpGN5OVq/f93N9FgEQNjFcKQjHUUOhW8n3Xr1Eu4WRUE3wIxlLbggB9cNuAc9O5ZzRFytQU8bgi9vzTSgUDGtHYuW4qTSx1FpbkWQS4v78RyFzkrQEbY/cPlya9l9hvnpxUo7ZzoZBFpvzEUdtQqhFa9n4H36vQnP2txamGZtKXZxWiTmZHRqEbBQ2KYPA7lIuHnh55dknZeU2zv5Aar0k3qWXjgSwXM2/BA1nsgVd5RMlQRz1/Y2P9jhrswL1iabrVc7jZgRH/bE7SxTXGk1hdZwX8vdpEY8B+1TkHm7jCRSQvRoE1YvpEPPIoynLxrMMvBT9HQTudDuyBgM8aIocLwxVVPjcF/bUJMzmj7HwrgEq2P9hysOcLfSYAkKU7cnAf10Y7E8ogOxKCah+IuCw2Mj2N2fsr+eE5la4sF8VTSf6jaW6+e0SufnCxGdhX9IAV/2yScYKiofpqySi/S313iYxXG3a/QS2+Am6/DybR0viyN4uEbkPZu2mK7DYJ
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(396003)(376002)(1800799003)(186006)(451199021)(82310400008)(40470700004)(36840700001)(46966006)(478600001)(81166007)(356005)(82740400003)(86362001)(316002)(2616005)(336012)(70586007)(26005)(107886003)(6506007)(70206006)(6512007)(110136005)(6486002)(54906003)(6666004)(4326008)(40460700003)(41300700001)(2906002)(83380400001)(47076005)(40480700001)(36756003)(36860700001)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2023 10:27:45.6873
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad3a035f-ec4d-44c7-f4ce-08db97fa1b3c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT003.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10361

The 08/01/2023 16:09, Mark Brown wrote:
> On Tue, Aug 01, 2023 at 03:13:20PM +0100, Will Deacon wrote:
> > On Mon, Jul 31, 2023 at 02:43:09PM +0100, Mark Brown wrote:
> 
> > > The arm64 Guarded Control Stack (GCS) feature provides support for
> > > hardware protected stacks of return addresses, intended to provide
> > > hardening against return oriented programming (ROP) attacks and to make
> > > it easier to gather call stacks for applications such as profiling.
> 
> > Why is this better than Clang's software shadow stack implementation? It
> > would be nice to see some justification behind adding all this, rather
> > than it being an architectural tick-box exercise.
> 
> Mainly that it's hardware enforced (as the quoted paragraph says).  This
> makes it harder to attack, and hopefully it's also a bit faster (how
> measurable that might be will be an open question, but even NOPs in
> function entry/exit tend to get noticed).

clang shadowstack seems to use x18. this is only valid on a
platform like android that can reserve x18, not deployable
widely on linux distros.

with gcs the same binary works with gcs enabled or disabled.
and it can support disabling gcs at runtime. this is
important for incremental deployment or with late detection
of incompatibility. clang shadowstack cannot do this. (and
there is no abi marking so it is easy to create broken
binaries.)

android uses fixed 16k shadowstack, controlling this size
from userspace is missing from the current gcs abi patches.
the default gcs size can be huge so this may be an actual
issue for gcs on android where RLIMIT_AS, RLIMIT_DATA etc
are often set i think. but the fixed size has its problems
too (e.g. there are libraries, boehm gc, that recursively
call a function until segfault to detect stack bounds).

i think the clang shadowstack design does not allow safely
switching between shadow stacks. bionic has no makecontext
so code that does userspace task scheduling presumably has
to do custom things which would need modifications and likely
introdce security weakness where x18 is set. (this also means
sigaltstack would have the same limitations as the current
gcs patches: shadow stack overflow cannot be handled if the
signal handler itself wants to use the same shadow stack. one
advantage of the weaker software solution is that it can be
disabled per function however a signal handler may indirectly
call many other functions so i'm not sure if this helps in
practice.)

as usual with these sanitizers we cannot recommend them to
users in general: they only work in a narrow context. to be
fair shstk and gcs are only a little bit better in this case.

