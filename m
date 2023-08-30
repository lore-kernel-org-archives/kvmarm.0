Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2050.outbound.protection.outlook.com [40.107.13.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D460520E2
	for <kvmarm@lists.linux.dev>; Wed, 30 Aug 2023 12:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wV8mPRMaR1P1rFQgy90FKbO/pA1JI7UIbXfKBiXscyc=;
 b=0HECq+n//99ifwPs3hI25BCyHpAMZZ8HmFsRml8mk4x3kt/6OnDOi0++4f4yiddYjjNsBjMCJOjEsd4G99DKZetc2Bd2gbKzDK5+zZn2ix5flWm/lmTGQdA+R4aDSPQ/iIILQXAQ84ofVyyJel8VLLMUe53rn3fOi/T1LN4B7c8=
Received: from AM0PR04CA0039.eurprd04.prod.outlook.com (2603:10a6:208:1::16)
 by AS8PR08MB6696.eurprd08.prod.outlook.com (2603:10a6:20b:395::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.35; Wed, 30 Aug
 2023 12:38:04 +0000
Received: from AM7EUR03FT036.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:208:1:cafe::a3) by AM0PR04CA0039.outlook.office365.com
 (2603:10a6:208:1::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.20 via Frontend
 Transport; Wed, 30 Aug 2023 12:38:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT036.mail.protection.outlook.com (100.127.140.93) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6745.20 via Frontend Transport; Wed, 30 Aug 2023 12:38:03 +0000
Received: ("Tessian outbound 169aaa6bf2b7:v175"); Wed, 30 Aug 2023 12:38:03 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: f3df13224b1ec5d9
X-CR-MTA-TID: 64aa7808
Received: from 0e08af961bde.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id A930DF65-6BEA-493C-90C7-95D9A52A42EA.1;
	Wed, 30 Aug 2023 12:37:53 +0000
Received: from EUR03-AM7-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0e08af961bde.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 30 Aug 2023 12:37:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhSWutMyJ1kSENpbrpQZWrTUeJcqMGO4/nJxBzKoKGP0b6PqtRgz5sDosrqxeop9uSlq9j3tuOcMK6o0LqkrUvJHHYUHIRWSGGzDGdzy1Aac7no8MMAszMVgNaBmMnI9qdyQ+gHK2PmHUd+SaZCPaCIhbsIC7o7kVMPYD7RM9zjYE1zIIZmnkV5Xz8fFJhpQMlncfrpEBrYaqvDdbu9MRD9YeaQDSPQyFrrzExx7sH2fffliO5redpoLN9mHYDvHvgJerd88+4mLhtn66jOo2Bs/Bg/D4uJgfJGpREZHdJte5ZNgZ5biUDkxYpB9Q+sUwl1IN2iVZkaRCM+zKWKBzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wV8mPRMaR1P1rFQgy90FKbO/pA1JI7UIbXfKBiXscyc=;
 b=lQK7A0ALSYRQUMmHvrZQnrtBr+hFioYgWXxmg1snXS7uh4KqhyKprV8TFxLa4ZyS3qD79XkY/6K4oJGKEk6/OuOILUIF/eHJCtY0aD/sgmsDla5CVMCuKgLHq2+w3hEAyUE/XVCOy3sQSq7Iwz+0/H7x2T1aA92LC1SwwMQwcn9e9smMCCwJsIJaGiSPxyL/CqHyA02aDWgc52H4YrJnPsJ+8VS+tzEIHDj6c8SDe41xoZ1IqkIym6kTiO1QU0fcjXLlhTM/KQ12FUD9AgHlO8v/KnH3Swjom6ww2P9aJ0HaswUG/gakTJzvqZ/0YMiqg9vT3/ysEYDpUs72bVU5pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wV8mPRMaR1P1rFQgy90FKbO/pA1JI7UIbXfKBiXscyc=;
 b=0HECq+n//99ifwPs3hI25BCyHpAMZZ8HmFsRml8mk4x3kt/6OnDOi0++4f4yiddYjjNsBjMCJOjEsd4G99DKZetc2Bd2gbKzDK5+zZn2ix5flWm/lmTGQdA+R4aDSPQ/iIILQXAQ84ofVyyJel8VLLMUe53rn3fOi/T1LN4B7c8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by DB9PR08MB6393.eurprd08.prod.outlook.com (2603:10a6:10:25a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.20; Wed, 30 Aug
 2023 12:37:50 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::adb0:61cb:8733:6db2]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::adb0:61cb:8733:6db2%7]) with mapi id 15.20.6745.020; Wed, 30 Aug 2023
 12:37:50 +0000
Date: Wed, 30 Aug 2023 13:37:33 +0100
From: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
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
Subject: Re: [PATCH v4 03/36] arm64/gcs: Document the ABI for Guarded Control
 Stacks
Message-ID: <ZO84DWEiYk6dU3iR@arm.com>
References: <ZN+qki9EaZ6f9XNi@arm.com>
 <aaea542c-929c-4c9b-8caa-ca67e0eb9c1e@sirena.org.uk>
 <ZOTnL1SDJWZjHPUW@arm.com>
 <43ec219d-bf20-47b8-a5f8-32bc3b64d487@sirena.org.uk>
 <ZOXa98SqwYPwxzNP@arm.com>
 <227e6552-353c-40a9-86c1-280587a40e3c@sirena.org.uk>
 <ZOY3lz+Zyhd5ZyQ9@arm.com>
 <ZOZEmO6WGyVAcOqK@arm.com>
 <ef7272d2-d807-428f-9915-6fc9febadb5c@sirena.org.uk>
 <ZOd6lzj29VksAp7L@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZOd6lzj29VksAp7L@arm.com>
X-ClientProxiedBy: LO4P123CA0550.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::20) To DB9PR08MB7179.eurprd08.prod.outlook.com
 (2603:10a6:10:2cc::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DB9PR08MB7179:EE_|DB9PR08MB6393:EE_|AM7EUR03FT036:EE_|AS8PR08MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: d6ae0661-1f40-43d4-27f7-08dba955f441
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 cNAz/hpoSFm1p+4pzfjNhQORnvLX83LoV7Dl6XnLmgKDXaFe7I534uViSj2bd9s10w48rqzxrYplFxgNc7FdiEc1GUnB64H+HOwxGLH/tJnOiwFpSi5H+PI1JomPuA7qc9w7QaCk715nxzM43D9AxcFICBrMqX4BTR9lRFwma2UtGIVW6Tzxaokhcv0S4WUwNexlDEzrNLCGL4FbAFv6KPXSvguOW2KaDaVUCYUxDgx/RBUlCNOVQFPynPi8L4ishHm9WtCFo+ts836y7LBNdIDkMB0ROfSdTZCGXbXtrHKPwiJC5Ak87QNHll69wBuooBIv4yhX1E77m2XcEzAPVg3+sJ4reRSPYyMjQGNbgqMhkqp51gNpsRYt9Fev3FVjZPesSL95AfLo/+iP76S4IjHWQCiQtXZTgvs0wk72TGWm0cC0fYgzA7u94Xc4KNDxSmFB95ECMHksq5CWgN0PhzMcgrk2n/tZSyFNDJSb0qmUqmqQ7kjPmLcAPQ8Sp06tJPsO0Eg8jIWYziWfJI+K0k056IZiOaNWd/vwlJ714qpIHYn2kniuJnsIOVmQ9TNb
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB7179.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(136003)(376002)(366004)(396003)(451199024)(1800799009)(186009)(6486002)(6666004)(6512007)(6506007)(83380400001)(478600001)(2906002)(26005)(110136005)(7416002)(41300700001)(66476007)(66946007)(66556008)(54906003)(316002)(8676002)(8936002)(5660300002)(4326008)(36756003)(2616005)(38100700002)(86362001)(66899024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6393
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT036.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8116f766-498c-49e6-ce34-08dba955eb68
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6fOGA/ktPv8/EnkHBWZ06t+4lvKSLKmzWfKecUWnpr8NcQs4MWHMSJG80/YdZv+PA9VRnP8QPR5v7Lt6HvNp6FaUbpRTodKIzaszkb7fgm3xtkSKY5LdCxpZtDhBajb4de8FL+QtqXRQNuSfXDAKXZhimvUjyQK0WgN1hUjWvQFbjPvlrJMBikOHD/qyFdItpbDBKCtMvI7iLTNkxtcZW183vxljywtDx+5altKstO0tMjJLs9O0+sAGJO/dEgCJkPKaOOA7Jv3CpVgifvTNBTBy/u0Ei8E/49LZmJbJSipN369cqA+HkI08dhsMjeerna3eMuRCrEY1h7UKKWYqQ0cjPLpCFkSRjSPyHIyV1hV0T8KC0OovkMu9Xvlc8U6SD6xGNRRnbIp0aD5u4UZqQabFAS7v/TT5VQAtohkIrjPGdjhniprv+n6HD7dh3MngycsSbRbalkhw0kkiUKT9pKwecNapHuBj9y5PEN1fpoa2F5Zs8Jb2oy42/W83v2R+eRCO8fHs1uEajwUi8Dy5Z/umfP70z5FwKuvjv3dQRDcejR8icrt3sahfX1VQm6DGwwz2Hf2rOeRdE1FDjpayAlR15snlS5oW5sJGokxsR/uR+P+8AHFRQmmSgT9xLjA3woJMvuu6DEQ8ThHJNIrtMa5eZlqu5/fp8oa/o/C4cf4z+5bnK/hFPDRZ6qFmKvsAt5aJPIXM6AgPC6eJfF7WA/vavmS09CNk4BB4XN32CPS8VNkBYEAZWQ41nig2JahQ
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(136003)(376002)(39860400002)(1800799009)(186009)(451199024)(82310400011)(46966006)(40470700004)(36840700001)(81166007)(356005)(82740400003)(8936002)(6666004)(110136005)(70206006)(478600001)(70586007)(6506007)(54906003)(6486002)(316002)(41300700001)(66899024)(40460700003)(6512007)(8676002)(5660300002)(36756003)(107886003)(83380400001)(2906002)(2616005)(47076005)(86362001)(36860700001)(40480700001)(26005)(336012)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2023 12:38:03.7657
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6ae0661-1f40-43d4-27f7-08dba955f441
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT036.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6696

The 08/24/2023 16:43, Catalin Marinas wrote:
> Is there a use-case for the unlocked configuration to allow disabling
> the GCS implicitly via a clone syscall?

how would you handle clone or clone3 without gcs specified?
(in the cases when clone creates a new thread with new stack)

(1) fail.
(2) allocate gcs.
(3) disable gcs.

the problem with (1) is that it requires changes to user code
(this only affects code outside the libc doing something special
since raw clone thread cannot call into the libc, all executing
code have to be tightly controlled. i don't know how common this
is, but i at least expect it in test code for system level tools
like debuggers, strace, valgrind, qemu-system, seccomp filters
etc. if it appears in actual use then that's a deployment issue
for distros: note that changing clone to clone3 is non-trivial:
it requires fallback logic and may have to deal with seccomp
filters).

problem with (2) is that the size policy and lifetime management
is in the kernel then. (since only special cases are affected i
guess that is ok, but i assumed we want to avoid this by moving
to clone3 and user managed gcs).

the problem with (3) is escaping the security measure, however
it only applies to very special threads that can always decide
to opt-in to gcs, so i don't see this as such a bad option and
at least bw compat with existing code. (in my threat model the
attacker cannot hijack clone syscalls as that seems stronger
than hijacking return addresses.)

so i guess the answer depends on how much headache failing
raw clone may cause and i don't know that.
