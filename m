Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2077.outbound.protection.outlook.com [40.107.20.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A922186C
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 08:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mi1qf36m/mTqKe3vJloNVLdrTzLce1aT1KSvGuMJKoA=;
 b=Z4Gz82LdjRLjfKpHxCI3NFLjtyswerHSbuodFMasB/abw50nZtODKQY58hUIwTlcWr2yolXnrqHkpy05jkSIbu63hyqmJaZKS6MhDVcMNnIt+atMKHGIrPe6a6IUricOckUyAU6Ykw2t7wx7Txzn3y+85zcLjZyN5+h8ioU+rXU=
Received: from AM0PR04CA0089.eurprd04.prod.outlook.com (2603:10a6:208:be::30)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 08:56:28 +0000
Received: from AM7EUR03FT064.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:208:be:cafe::1a) by AM0PR04CA0089.outlook.office365.com
 (2603:10a6:208:be::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30 via Frontend
 Transport; Thu, 10 Aug 2023 08:56:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT064.mail.protection.outlook.com (100.127.140.127) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.19 via Frontend Transport; Thu, 10 Aug 2023 08:56:28 +0000
Received: ("Tessian outbound 95df046a2e2c:v145"); Thu, 10 Aug 2023 08:56:28 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 53f5cf8641134430
X-CR-MTA-TID: 64aa7808
Received: from 27ff08b2fa1b.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 6B8C4B36-B788-475D-9893-4184938AA0D8.1;
	Thu, 10 Aug 2023 08:56:18 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 27ff08b2fa1b.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 10 Aug 2023 08:56:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOz+Uy1nqfe00bCYkivjZog8AS0gqkbjm9v5h+W+JC4NO7C9FANLx6vQvhcDK1ZeAx8EfxCNZEdgTutNtDynhexZo67a3W0AdkVGf4GjMof6g6P8COx4Xq5TBCTDbFOMb1Avy4OLu3La3IAdFDHErlyLURI45NnB2TvfuneAd7qLS5Yr539kdpOprqZHBdxPuNniqhoLG4tbbpRotKKCg4066YzegYsTdtA9/SBPlPFAXExKGQxmbJr/5OLIDTlKdehMNq+hwOogPa47Yb5ZrWdoF9AH/uGGIb0FLtAgMGMT1QP0WMhdNPmAGopLOB8xJWy1WSimc86EMvWYqel2Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mi1qf36m/mTqKe3vJloNVLdrTzLce1aT1KSvGuMJKoA=;
 b=MHXi2Nv04vPQnBXwDcH9TCL1ajWaGkkGQymNfaOjLOm6qQHp9sZG0kXPIWjYvJNcHWrEKRaZaLUoyUI3LAkHE1XOIdLXq3eyKS+mY9JO+ueVJhfAnahEujOwqg+6iP3ystF6mGa6JORCf6BqxHJbMsDS+zzax/ZQQYME7ti1OM3lyZPGzWc3QRL5M+W+9ksRkBTuB+weJ/nr0AAsctJWZn4Y26ln4ZRqhwK3TASrMLPHuT+TZkBt40sZl+wdEaZaQwOsVDs53r/yqZUk3JyWuZEJ78jDFOsWGcb0gDls6AKhi46bXnY95ME+vCnDpEVaMtziOIZcv0Oi2XwRKwE20g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mi1qf36m/mTqKe3vJloNVLdrTzLce1aT1KSvGuMJKoA=;
 b=Z4Gz82LdjRLjfKpHxCI3NFLjtyswerHSbuodFMasB/abw50nZtODKQY58hUIwTlcWr2yolXnrqHkpy05jkSIbu63hyqmJaZKS6MhDVcMNnIt+atMKHGIrPe6a6IUricOckUyAU6Ykw2t7wx7Txzn3y+85zcLjZyN5+h8ioU+rXU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by AS2PR08MB9618.eurprd08.prod.outlook.com (2603:10a6:20b:609::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 08:56:14 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::adb0:61cb:8733:6db2]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::adb0:61cb:8733:6db2%7]) with mapi id 15.20.6652.028; Thu, 10 Aug 2023
 08:56:14 +0000
Date: Thu, 10 Aug 2023 09:55:50 +0100
From: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
To: Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
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
Message-ID: <ZNSmFmYFHDw3NvvP@arm.com>
References: <20230807-arm64-gcs-v4-0-68cfa37f9069@kernel.org>
 <20230807-arm64-gcs-v4-3-68cfa37f9069@kernel.org>
 <ZNOhjrYleGBR6Pbs@arm.com>
 <f4cec4b3-c386-4873-aa1d-90528e062f2a@sirena.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f4cec4b3-c386-4873-aa1d-90528e062f2a@sirena.org.uk>
X-ClientProxiedBy: SA1P222CA0098.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:35e::8) To DB9PR08MB7179.eurprd08.prod.outlook.com
 (2603:10a6:10:2cc::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DB9PR08MB7179:EE_|AS2PR08MB9618:EE_|AM7EUR03FT064:EE_|DB9PR08MB8483:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ce23c27-33dd-46f8-801b-08db997faf85
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 YPww17Wa3xYHTX2cruJRFvAl9IrbdGyP1ACX4Nq5+AgfGbjQ7LA1uGnijNORkie0hxQFfdSG3SRJ5uB6pIqrYq3QbpOXrEFtH/2twI4qOo7gSDsG4PReXJeDPzY6x9QiL162gTKJxZjXrJ5rxtZJi06vf48vwSYLtGb/tVDuAMxogn/UIA1PKGhB+5Ty89tcx9otAw6Gu0hY0aDwVJwAiPQVeZyy2Tn5wS5po1klv8+RyooCTIngJD/Y0NqeWCCr3DOqyhxzx8rIdCxEm8L6rx/R0YG6WRynWpbFbY1kXUjvm/hLC7ZNDyNNcB82jOt/xtBK16CG35RGL21qTsoIH1lug2rimF4gT9JmO5f2RXDInJ+d97BhzhhgQ7J1rS1ayeU3r4Q/PVZP6xzDSCF6EJ5laBq/+l/Q9D9ElFyo6ObgKF4PQdGZAG9rozafCUKU+mJwTY+gq8mm0OAq5XGOBXVJ2QBKro1pPnoFZaPh34Xx6Y9o+8T0TpvijWljXEKm6GVtskaRObAbiSREabvKE9EpaJDAMQeUpHF/j+fWv5ZIzO4pPju/Ghp4UtWlIcn1
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB7179.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199021)(186006)(1800799006)(36756003)(6666004)(478600001)(110136005)(66556008)(6506007)(6636002)(66946007)(26005)(54906003)(66476007)(6486002)(4326008)(316002)(2906002)(7416002)(41300700001)(8676002)(5660300002)(38100700002)(86362001)(8936002)(83380400001)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9618
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT064.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6fd1b402-1226-45b2-c901-08db997fa69d
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	m62p4wxKY0CXdeTdB9cBaALAtRRcILQmdz8uSu5OwmRveBfLuNbhLjuGvHpujVWB1eVtpWmkD+RAHzmAWZfe0lwSthUetjGJvPGGjxpremxJGcwvZW8yMpeD/cYVbaIPE7xytBRyFCkCC+Z4b/MPDnJmphYiLkDv/ua9czu8ANStyLAyBaJj/wl39S6bm78MT3Wni+xRlf3nTIUu/DVPvivjI01jro+/SAl33uYZkgOmlGd8OFx7Mn29ih5f76TpCyChhwpUnPt+j4XkTfWBTY3KQDyS7850gwtSRw2GyLKewfphnyXen9nIswBNnjEM9wR8rwzDEoZXYwuAM8aC1msK4+fkZPJR7w2O+BsCuSSPVUMR5SxvdqoyGcHrtr50CtYUNzJxipjlQIauemqZC0LjIhVOpJ/nRtwFNjC+OBOxPNlEMmrmk/ISQgV+8c8zSI3gnLZqPJM8lL/kpgGvu2V2X2w9QX47EZT5cCzCbzLa7TYGgsZW+8+W+DETDf96K7NnDtH9YrMAMoBqBL0dXz5LPs2xDm0KyD0hTlEFg8KQzR5oLtDPJ/rvvu09Y+e3M2tWst+rx7mX21n78AFHUxG2vc0Q1t7kSEziui7n91KfVFRymkT9CWWLelr3rZSnYUhWNyd3fld/cUH5chU8d9UXEIHb+xn7oI62Urz0neSbL2Q9abt4eTe1onVS14U3NBzjT7DvHDFEu+VxcRaemHoNxuaVzUQWaUaxBSTCVfw=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(39860400002)(136003)(186006)(451199021)(82310400008)(1800799006)(46966006)(36840700001)(40470700004)(47076005)(40460700003)(83380400001)(54906003)(110136005)(2906002)(6512007)(336012)(36756003)(6506007)(107886003)(26005)(6666004)(86362001)(6486002)(478600001)(40480700001)(2616005)(70586007)(70206006)(316002)(6636002)(4326008)(8676002)(8936002)(81166007)(356005)(5660300002)(82740400003)(41300700001)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2023 08:56:28.7090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce23c27-33dd-46f8-801b-08db997faf85
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT064.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483

The 08/09/2023 16:34, Mark Brown wrote:
> On Wed, Aug 09, 2023 at 03:24:14PM +0100, Catalin Marinas wrote:
> > On Mon, Aug 07, 2023 at 11:00:08PM +0100, Mark Brown wrote:
> > > +* When GCS is enabled for a thread a new Guarded Control Stack will be
> > > +  allocated for it of size RLIMIT_STACK / 2 or 2 gigabytes, whichever is
> > > +  smaller.
> 
> > Is this number based on the fact that a function call would only push
> > the LR to GCS while standard function prologue pushes at least two
> > registers?
> 
> It's actually based on bitrot that I'd initially chosen a smaller value
> since it's likely that functions will push at least something as you
> suggest, the patches now just use RLIMIT_STACK.  I'll fix.

the pcs requires 16byte aligned stack frames, with 8byte per gcs entry
there is no need for same gcs size as stack size in userspace.

you can argue about a fixed size small increment (stacksize/2 + inc)
for signal handling on alt stack and special tokens, but stack size is
overkill i think.

fwiw my current makecontext patch uses roundup(stacksize/2+160).
(threads guaranteed to have about 300bytes of data on the stack in glibc
so if gcs is stacksize/2, that accounts for the increment. this is for
the theoretical case when an empty thread just tries to overflow the
stack and then handle the fault on sigaltstack.)
