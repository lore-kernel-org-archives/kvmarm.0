From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: Filter out invalid core register IDs
 in KVM_GET_REG_LIST
Date: Thu, 13 Dec 2018 18:30:39 +0000
Message-ID: <20181213183038.GC3505@e103592.cambridge.arm.com>
References: <1544645824-16461-1-git-send-email-Dave.Martin@arm.com>
 <1544645824-16461-2-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1544645824-16461-2-git-send-email-Dave.Martin@arm.com>
Sender: stable-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 12, 2018 at 08:17:03PM +0000, Dave Martin wrote:
> Since commit d26c25a9d19b ("arm64: KVM: Tighten guest core register
> access from userspace"), KVM_{GET,SET}_ONE_REG rejects register IDs
> that do not correspond to a single underlying architectural register.
> 
> KVM_GET_REG_LIST was not changed to match however: instead, it
> simply yields a list of 32-bit register IDs that together cover the
> whole kvm_regs struct.  This means that if userspace tries to use
> the resulting list of IDs directly to drive calls to KVM_*_ONE_REG,
> some of those calls will now fail.
> 
> This was not the intention.  Instead, iterating KVM_*_ONE_REG over
> the list of IDs returned by KVM_GET_REG_LIST should be guaranteed
> to work.
> 
> This patch fixes the problem by splitting validate_core_reg_id()
> into a backend core_reg_size_from_offset() which does all of the
> work except for checking that the size field in the register ID
> matches, and kvm_arm_copy_reg_indices() and num_core_regs() are
> converted to use this to enumerate the valid offsets.
> 
> kvm_arm_copy_reg_indices() now also sets the register ID size field
> appropriately based on the value returned, so the register ID
> supplied to userspace is fully qualified for use with the register
> access ioctls.
> 
> Cc: stable@vger.kernel.org
> Fixes: d26c25a9d19b ("arm64: KVM: Tighten guest core register access from userspace")
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>

Tested now with [1], which obtains the reg list with KVM_GET_REG_LIST
and then tries to read each register listed.

(Comparing v4.19 with a patches v4.20-rc5 was a bit lazy here, but there
is no reason to suppose the results would be different.)


This confirms both the exactly expected bug behaviour and the fix.


I have not yet checked what qemu does with the KVM_GET_REG_LIST data.

Cheers
---Dave

--8<--

--- reglist-4.19.0	2018-12-13 18:14:03.970008568 +0000
+++ reglist-4.20.0-rc5-00001-gc80a4e51b4d3	2018-12-13 17:50:08.281045482 +0000
@@ -1,461 +1,321 @@
 KVM_GET_REG_LIST: Exec format error
 KVM_ARM_PREFERRED_TARGET:
 	target = 5
 	features[0] = 0x00000000
 	features[0] = 0x00000000
 	features[0] = 0x00000000
 	features[0] = 0x00000000
 	features[0] = 0x00000000
 	features[0] = 0x00000000
 	features[0] = 0x00000000
 	0x6030000000100000	OK
-	0x6030000000100001	FAIL (Invalid argument)
 	0x6030000000100002	OK
-	0x6030000000100003	FAIL (Invalid argument)
 	0x6030000000100004	OK
-	0x6030000000100005	FAIL (Invalid argument)
 	0x6030000000100006	OK
-	0x6030000000100007	FAIL (Invalid argument)
 	0x6030000000100008	OK
-	0x6030000000100009	FAIL (Invalid argument)
 	0x603000000010000a	OK
-	0x603000000010000b	FAIL (Invalid argument)
 	0x603000000010000c	OK
-	0x603000000010000d	FAIL (Invalid argument)
 	0x603000000010000e	OK
-	0x603000000010000f	FAIL (Invalid argument)
 	0x6030000000100010	OK
-	0x6030000000100011	FAIL (Invalid argument)
 	0x6030000000100012	OK
-	0x6030000000100013	FAIL (Invalid argument)
 	0x6030000000100014	OK
-	0x6030000000100015	FAIL (Invalid argument)
 	0x6030000000100016	OK
-	0x6030000000100017	FAIL (Invalid argument)
 	0x6030000000100018	OK
-	0x6030000000100019	FAIL (Invalid argument)
 	0x603000000010001a	OK
-	0x603000000010001b	FAIL (Invalid argument)
 	0x603000000010001c	OK
-	0x603000000010001d	FAIL (Invalid argument)
 	0x603000000010001e	OK
-	0x603000000010001f	FAIL (Invalid argument)
 	0x6030000000100020	OK
-	0x6030000000100021	FAIL (Invalid argument)
 	0x6030000000100022	OK
-	0x6030000000100023	FAIL (Invalid argument)
 	0x6030000000100024	OK
-	0x6030000000100025	FAIL (Invalid argument)
 	0x6030000000100026	OK
-	0x6030000000100027	FAIL (Invalid argument)
 	0x6030000000100028	OK
-	0x6030000000100029	FAIL (Invalid argument)
 	0x603000000010002a	OK
-	0x603000000010002b	FAIL (Invalid argument)
 	0x603000000010002c	OK
-	0x603000000010002d	FAIL (Invalid argument)
 	0x603000000010002e	OK
-	0x603000000010002f	FAIL (Invalid argument)
 	0x6030000000100030	OK
-	0x6030000000100031	FAIL (Invalid argument)
 	0x6030000000100032	OK
-	0x6030000000100033	FAIL (Invalid argument)
 	0x6030000000100034	OK
-	0x6030000000100035	FAIL (Invalid argument)
 	0x6030000000100036	OK
-	0x6030000000100037	FAIL (Invalid argument)
 	0x6030000000100038	OK
-	0x6030000000100039	FAIL (Invalid argument)
 	0x603000000010003a	OK
-	0x603000000010003b	FAIL (Invalid argument)
 	0x603000000010003c	OK
-	0x603000000010003d	FAIL (Invalid argument)
 	0x603000000010003e	OK
-	0x603000000010003f	FAIL (Invalid argument)
 	0x6030000000100040	OK
-	0x6030000000100041	FAIL (Invalid argument)
 	0x6030000000100042	OK
-	0x6030000000100043	FAIL (Invalid argument)
 	0x6030000000100044	OK
-	0x6030000000100045	FAIL (Invalid argument)
 	0x6030000000100046	OK
-	0x6030000000100047	FAIL (Invalid argument)
 	0x6030000000100048	OK
-	0x6030000000100049	FAIL (Invalid argument)
 	0x603000000010004a	OK
-	0x603000000010004b	FAIL (Invalid argument)
 	0x603000000010004c	OK
-	0x603000000010004d	FAIL (Invalid argument)
 	0x603000000010004e	OK
-	0x603000000010004f	FAIL (Invalid argument)
 	0x6030000000100050	OK
-	0x6030000000100051	FAIL (Invalid argument)
-	0x6030000000100052	FAIL (Invalid argument)
-	0x6030000000100053	FAIL (Invalid argument)
-	0x6030000000100054	FAIL (Invalid argument)
-	0x6030000000100055	FAIL (Invalid argument)
-	0x6030000000100056	FAIL (Invalid argument)
-	0x6030000000100057	FAIL (Invalid argument)
-	0x6030000000100058	FAIL (Invalid argument)
-	0x6030000000100059	FAIL (Invalid argument)
-	0x603000000010005a	FAIL (Invalid argument)
-	0x603000000010005b	FAIL (Invalid argument)
-	0x603000000010005c	FAIL (Invalid argument)
-	0x603000000010005d	FAIL (Invalid argument)
-	0x603000000010005e	FAIL (Invalid argument)
-	0x603000000010005f	FAIL (Invalid argument)
-	0x6030000000100060	FAIL (Invalid argument)
-	0x6030000000100061	FAIL (Invalid argument)
-	0x6030000000100062	FAIL (Invalid argument)
-	0x6030000000100063	FAIL (Invalid argument)
-	0x6030000000100064	FAIL (Invalid argument)
-	0x6030000000100065	FAIL (Invalid argument)
-	0x6030000000100066	FAIL (Invalid argument)
-	0x6030000000100067	FAIL (Invalid argument)
-	0x6030000000100068	FAIL (Invalid argument)
-	0x6030000000100069	FAIL (Invalid argument)
-	0x603000000010006a	FAIL (Invalid argument)
-	0x603000000010006b	FAIL (Invalid argument)
-	0x603000000010006c	FAIL (Invalid argument)
-	0x603000000010006d	FAIL (Invalid argument)
-	0x603000000010006e	FAIL (Invalid argument)
-	0x603000000010006f	FAIL (Invalid argument)
-	0x6030000000100070	FAIL (Invalid argument)
-	0x6030000000100071	FAIL (Invalid argument)
-	0x6030000000100072	FAIL (Invalid argument)
-	0x6030000000100073	FAIL (Invalid argument)
-	0x6030000000100074	FAIL (Invalid argument)
-	0x6030000000100075	FAIL (Invalid argument)
-	0x6030000000100076	FAIL (Invalid argument)
-	0x6030000000100077	FAIL (Invalid argument)
-	0x6030000000100078	FAIL (Invalid argument)
-	0x6030000000100079	FAIL (Invalid argument)
-	0x603000000010007a	FAIL (Invalid argument)
-	0x603000000010007b	FAIL (Invalid argument)
-	0x603000000010007c	FAIL (Invalid argument)
-	0x603000000010007d	FAIL (Invalid argument)
-	0x603000000010007e	FAIL (Invalid argument)
-	0x603000000010007f	FAIL (Invalid argument)
-	0x6030000000100080	FAIL (Invalid argument)
-	0x6030000000100081	FAIL (Invalid argument)
-	0x6030000000100082	FAIL (Invalid argument)
-	0x6030000000100083	FAIL (Invalid argument)
-	0x6030000000100084	FAIL (Invalid argument)
-	0x6030000000100085	FAIL (Invalid argument)
-	0x6030000000100086	FAIL (Invalid argument)
-	0x6030000000100087	FAIL (Invalid argument)
-	0x6030000000100088	FAIL (Invalid argument)
-	0x6030000000100089	FAIL (Invalid argument)
-	0x603000000010008a	FAIL (Invalid argument)
-	0x603000000010008b	FAIL (Invalid argument)
-	0x603000000010008c	FAIL (Invalid argument)
-	0x603000000010008d	FAIL (Invalid argument)
-	0x603000000010008e	FAIL (Invalid argument)
-	0x603000000010008f	FAIL (Invalid argument)
-	0x6030000000100090	FAIL (Invalid argument)
-	0x6030000000100091	FAIL (Invalid argument)
-	0x6030000000100092	FAIL (Invalid argument)
-	0x6030000000100093	FAIL (Invalid argument)
-	0x6030000000100094	FAIL (Invalid argument)
-	0x6030000000100095	FAIL (Invalid argument)
-	0x6030000000100096	FAIL (Invalid argument)
-	0x6030000000100097	FAIL (Invalid argument)
-	0x6030000000100098	FAIL (Invalid argument)
-	0x6030000000100099	FAIL (Invalid argument)
-	0x603000000010009a	FAIL (Invalid argument)
-	0x603000000010009b	FAIL (Invalid argument)
-	0x603000000010009c	FAIL (Invalid argument)
-	0x603000000010009d	FAIL (Invalid argument)
-	0x603000000010009e	FAIL (Invalid argument)
-	0x603000000010009f	FAIL (Invalid argument)
-	0x60300000001000a0	FAIL (Invalid argument)
-	0x60300000001000a1	FAIL (Invalid argument)
-	0x60300000001000a2	FAIL (Invalid argument)
-	0x60300000001000a3	FAIL (Invalid argument)
-	0x60300000001000a4	FAIL (Invalid argument)
-	0x60300000001000a5	FAIL (Invalid argument)
-	0x60300000001000a6	FAIL (Invalid argument)
-	0x60300000001000a7	FAIL (Invalid argument)
-	0x60300000001000a8	FAIL (Invalid argument)
-	0x60300000001000a9	FAIL (Invalid argument)
-	0x60300000001000aa	FAIL (Invalid argument)
-	0x60300000001000ab	FAIL (Invalid argument)
-	0x60300000001000ac	FAIL (Invalid argument)
-	0x60300000001000ad	FAIL (Invalid argument)
-	0x60300000001000ae	FAIL (Invalid argument)
-	0x60300000001000af	FAIL (Invalid argument)
-	0x60300000001000b0	FAIL (Invalid argument)
-	0x60300000001000b1	FAIL (Invalid argument)
-	0x60300000001000b2	FAIL (Invalid argument)
-	0x60300000001000b3	FAIL (Invalid argument)
-	0x60300000001000b4	FAIL (Invalid argument)
-	0x60300000001000b5	FAIL (Invalid argument)
-	0x60300000001000b6	FAIL (Invalid argument)
-	0x60300000001000b7	FAIL (Invalid argument)
-	0x60300000001000b8	FAIL (Invalid argument)
-	0x60300000001000b9	FAIL (Invalid argument)
-	0x60300000001000ba	FAIL (Invalid argument)
-	0x60300000001000bb	FAIL (Invalid argument)
-	0x60300000001000bc	FAIL (Invalid argument)
-	0x60300000001000bd	FAIL (Invalid argument)
-	0x60300000001000be	FAIL (Invalid argument)
-	0x60300000001000bf	FAIL (Invalid argument)
-	0x60300000001000c0	FAIL (Invalid argument)
-	0x60300000001000c1	FAIL (Invalid argument)
-	0x60300000001000c2	FAIL (Invalid argument)
-	0x60300000001000c3	FAIL (Invalid argument)
-	0x60300000001000c4	FAIL (Invalid argument)
-	0x60300000001000c5	FAIL (Invalid argument)
-	0x60300000001000c6	FAIL (Invalid argument)
-	0x60300000001000c7	FAIL (Invalid argument)
-	0x60300000001000c8	FAIL (Invalid argument)
-	0x60300000001000c9	FAIL (Invalid argument)
-	0x60300000001000ca	FAIL (Invalid argument)
-	0x60300000001000cb	FAIL (Invalid argument)
-	0x60300000001000cc	FAIL (Invalid argument)
-	0x60300000001000cd	FAIL (Invalid argument)
-	0x60300000001000ce	FAIL (Invalid argument)
-	0x60300000001000cf	FAIL (Invalid argument)
-	0x60300000001000d0	FAIL (Invalid argument)
-	0x60300000001000d1	FAIL (Invalid argument)
-	0x60300000001000d2	FAIL (Invalid argument)
-	0x60300000001000d3	FAIL (Invalid argument)
-	0x60300000001000d4	FAIL (Invalid argument)
-	0x60300000001000d5	FAIL (Invalid argument)
-	0x60300000001000d6	FAIL (No such file or directory)
-	0x60300000001000d7	FAIL (No such file or directory)
+	0x6040000000100054	OK
+	0x6040000000100058	OK
+	0x604000000010005c	OK
+	0x6040000000100060	OK
+	0x6040000000100064	OK
+	0x6040000000100068	OK
+	0x604000000010006c	OK
+	0x6040000000100070	OK
+	0x6040000000100074	OK
+	0x6040000000100078	OK
+	0x604000000010007c	OK
+	0x6040000000100080	OK
+	0x6040000000100084	OK
+	0x6040000000100088	OK
+	0x604000000010008c	OK
+	0x6040000000100090	OK
+	0x6040000000100094	OK
+	0x6040000000100098	OK
+	0x604000000010009c	OK
+	0x60400000001000a0	OK
+	0x60400000001000a4	OK
+	0x60400000001000a8	OK
+	0x60400000001000ac	OK
+	0x60400000001000b0	OK
+	0x60400000001000b4	OK
+	0x60400000001000b8	OK
+	0x60400000001000bc	OK
+	0x60400000001000c0	OK
+	0x60400000001000c4	OK
+	0x60400000001000c8	OK
+	0x60400000001000cc	OK
+	0x60400000001000d0	OK
+	0x60200000001000d4	OK
+	0x60200000001000d5	OK
 	0x6030000000140000	OK
 	0x603000000013df19	OK
 	0x603000000013df1a	OK
 	0x603000000013df02	OK
 	0x603000000013c000	OK
 	0x603000000013c006	OK
 	0x603000000013c801	OK
 	0x603000000013c807	OK
 	0x603000000013d801	OK
 	0x6030000000138004	OK
 	0x6030000000138005	OK
 	0x6030000000138006	OK
 	0x6030000000138007	OK
 	0x603000000013800c	OK
 	0x603000000013800d	OK
 	0x603000000013800e	OK
 	0x603000000013800f	OK
 	0x6030000000138010	OK
 	0x6030000000138012	OK
 	0x6030000000138014	OK
 	0x6030000000138015	OK
 	0x6030000000138016	OK
 	0x6030000000138017	OK
 	0x603000000013801c	OK
 	0x603000000013801d	OK
 	0x603000000013801e	OK
 	0x603000000013801f	OK
 	0x6030000000138024	OK
 	0x6030000000138025	OK
 	0x6030000000138026	OK
 	0x6030000000138027	OK
 	0x603000000013802c	OK
 	0x603000000013802d	OK
 	0x603000000013802e	OK
 	0x603000000013802f	OK
 	0x6030000000138034	OK
 	0x6030000000138035	OK
 	0x6030000000138036	OK
 	0x6030000000138037	OK
 	0x603000000013803c	OK
 	0x603000000013803d	OK
 	0x603000000013803e	OK
 	0x603000000013803f	OK
 	0x6030000000138044	OK
 	0x6030000000138045	OK
 	0x6030000000138046	OK
 	0x6030000000138047	OK
 	0x603000000013804c	OK
 	0x603000000013804d	OK
 	0x603000000013804e	OK
 	0x603000000013804f	OK
 	0x6030000000138054	OK
 	0x6030000000138055	OK
 	0x6030000000138056	OK
 	0x6030000000138057	OK
 	0x603000000013805c	OK
 	0x603000000013805d	OK
 	0x603000000013805e	OK
 	0x603000000013805f	OK
 	0x6030000000138064	OK
 	0x6030000000138065	OK
 	0x6030000000138066	OK
 	0x6030000000138067	OK
 	0x603000000013806c	OK
 	0x603000000013806d	OK
 	0x603000000013806e	OK
 	0x603000000013806f	OK
 	0x6030000000138074	OK
 	0x6030000000138075	OK
 	0x6030000000138076	OK
 	0x6030000000138077	OK
 	0x603000000013807c	OK
 	0x603000000013807d	OK
 	0x603000000013807e	OK
 	0x603000000013807f	OK
 	0x603000000013a038	OK
 	0x603000000013c005	OK
 	0x603000000013c008	OK
 	0x603000000013c009	OK
 	0x603000000013c00a	OK
 	0x603000000013c00b	OK
 	0x603000000013c00c	OK
 	0x603000000013c00d	OK
 	0x603000000013c00e	OK
 	0x603000000013c00f	OK
 	0x603000000013c010	OK
 	0x603000000013c011	OK
 	0x603000000013c012	OK
 	0x603000000013c013	OK
 	0x603000000013c014	OK
 	0x603000000013c015	OK
 	0x603000000013c016	OK
 	0x603000000013c017	OK
 	0x603000000013c018	OK
 	0x603000000013c019	OK
 	0x603000000013c01a	OK
 	0x603000000013c01b	OK
 	0x603000000013c01c	OK
 	0x603000000013c01d	OK
 	0x603000000013c01e	OK
 	0x603000000013c01f	OK
 	0x603000000013c020	OK
 	0x603000000013c021	OK
 	0x603000000013c022	OK
 	0x603000000013c023	OK
 	0x603000000013c024	OK
 	0x603000000013c025	OK
 	0x603000000013c026	OK
 	0x603000000013c027	OK
 	0x603000000013c028	OK
 	0x603000000013c029	OK
 	0x603000000013c02a	OK
 	0x603000000013c02b	OK
 	0x603000000013c02c	OK
 	0x603000000013c02d	OK
 	0x603000000013c02e	OK
 	0x603000000013c02f	OK
 	0x603000000013c030	OK
 	0x603000000013c031	OK
 	0x603000000013c032	OK
 	0x603000000013c033	OK
 	0x603000000013c034	OK
 	0x603000000013c035	OK
 	0x603000000013c036	OK
 	0x603000000013c037	OK
 	0x603000000013c038	OK
 	0x603000000013c039	OK
 	0x603000000013c03a	OK
 	0x603000000013c03b	OK
 	0x603000000013c03c	OK
 	0x603000000013c03d	OK
 	0x603000000013c03e	OK
 	0x603000000013c03f	OK
 	0x603000000013c080	OK
 	0x603000000013c081	OK
 	0x603000000013c082	OK
 	0x603000000013c100	OK
 	0x603000000013c101	OK
 	0x603000000013c102	OK
 	0x603000000013c288	OK
 	0x603000000013c289	OK
 	0x603000000013c290	OK
 	0x603000000013c300	OK
 	0x603000000013c3a0	OK
 	0x603000000013c4f1	OK
 	0x603000000013c4f2	OK
 	0x603000000013c510	OK
 	0x603000000013c518	OK
 	0x603000000013c600	OK
 	0x603000000013c609	OK
 	0x603000000013c681	OK
 	0x603000000013c684	OK
 	0x603000000013c708	OK
 	0x603000000013d000	OK
 	0x603000000013dce1	OK
 	0x603000000013dce2	OK
 	0x603000000013dce3	OK
 	0x603000000013dce4	OK
 	0x603000000013dce5	OK
 	0x603000000013dce8	OK
 	0x603000000013dcf0	OK
 	0x603000000013dcf3	OK
 	0x603000000013de82	OK
 	0x603000000013de83	OK
 	0x603000000013df40	OK
 	0x603000000013df41	OK
 	0x603000000013df42	OK
 	0x603000000013df43	OK
 	0x603000000013df44	OK
 	0x603000000013df45	OK
 	0x603000000013df46	OK
 	0x603000000013df47	OK
 	0x603000000013df48	OK
 	0x603000000013df49	OK
 	0x603000000013df4a	OK
 	0x603000000013df4b	OK
 	0x603000000013df4c	OK
 	0x603000000013df4d	OK
 	0x603000000013df4e	OK
 	0x603000000013df4f	OK
 	0x603000000013df50	OK
 	0x603000000013df51	OK
 	0x603000000013df52	OK
 	0x603000000013df53	OK
 	0x603000000013df54	OK
 	0x603000000013df55	OK
 	0x603000000013df56	OK
 	0x603000000013df57	OK
 	0x603000000013df58	OK
 	0x603000000013df59	OK
 	0x603000000013df5a	OK
 	0x603000000013df5b	OK
 	0x603000000013df5c	OK
 	0x603000000013df5d	OK
 	0x603000000013df5e	OK
 	0x603000000013df60	OK
 	0x603000000013df61	OK
 	0x603000000013df62	OK
 	0x603000000013df63	OK
 	0x603000000013df64	OK
 	0x603000000013df65	OK
 	0x603000000013df66	OK
 	0x603000000013df67	OK
 	0x603000000013df68	OK
 	0x603000000013df69	OK
 	0x603000000013df6a	OK
 	0x603000000013df6b	OK
 	0x603000000013df6c	OK
 	0x603000000013df6d	OK
 	0x603000000013df6e	OK
 	0x603000000013df6f	OK
 	0x603000000013df70	OK
 	0x603000000013df71	OK
 	0x603000000013df72	OK
 	0x603000000013df73	OK
 	0x603000000013df74	OK
 	0x603000000013df75	OK
 	0x603000000013df76	OK
 	0x603000000013df77	OK
 	0x603000000013df78	OK
 	0x603000000013df79	OK
 	0x603000000013df7a	OK
 	0x603000000013df7b	OK
 	0x603000000013df7c	OK
 	0x603000000013df7d	OK
 	0x603000000013df7e	OK
 	0x603000000013df7f	OK
 	0x603000000013e180	OK
 	0x603000000013e281	OK
 	0x603000000013e298	OK
 	0x6020000000110000	OK
 	0x6020000000110001	OK
 	0x6020000000110002	OK
 	0x6020000000110004	OK
-FAIL
+
+PASS

[1]

#include <assert.h>
#include <errno.h>
#include <limits.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/kvm.h>

#define KVM_PATH "/dev/kvm"

#define ARRAY_SIZE(array) (sizeof (array) / sizeof *(array))

static int get_reg_list(int vcpu, struct kvm_reg_list **pregs, size_t *psize)
{
	struct kvm_reg_list *regs = *pregs;
	size_t num_needed = 0;
	const size_t reg_offset = (char *)&regs->reg - (char *)regs;

	while (1) {
		size_t size_needed = num_needed * sizeof regs->reg[0]
					+ reg_offset;
		if (size_needed > *psize) {
			regs = realloc(regs, size_needed);
			if (!regs)
				goto nomem;

			*pregs = regs;
			*psize = size_needed;
		}

		regs->n = (*psize - reg_offset) / sizeof regs->reg[0];
		if (!ioctl(vcpu, KVM_GET_REG_LIST, regs))
			break;

		if (errno != E2BIG) {
			perror("KVM_GET_REG_LIST");
			goto error;
		}

		num_needed = regs->n;
	}

	return 0;	

nomem:
	errno = ENOMEM;
	perror(NULL);
error:
	return -1;
}

int main(void)
{
	int fail = 0;
	int kvm_fd, vm, vcpu;
	struct kvm_vcpu_init init;
	size_t i;
	struct kvm_reg_list *regs = NULL;
	size_t regs_size = 0;
	uint64_t regdata[2];
	struct kvm_one_reg reg;

	kvm_fd = open(KVM_PATH, O_RDWR);
	if (kvm_fd == -1) {
		perror(KVM_PATH);
		goto error;
	}

	vm = ioctl(kvm_fd, KVM_CREATE_VM, 0);
	if (vm == -1) {
		perror("KVM_CREATE_VM");
		goto error;
	}

	if (ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init)) {
		perror("KVM_ARM_PREFERRED_TARGET");
		goto error;
	}

	printf("KVM_ARM_PREFERRED_TARGET:\n"
	       "\ttarget = %lu\n",
	       (unsigned long)init.target);
	for (i = 0; i < ARRAY_SIZE(init.features); ++i)
		printf("\tfeatures[0] = 0x%.8lx\n",
		       (unsigned long)init.features[i]);
	
	vcpu = ioctl(vm, KVM_CREATE_VCPU, 0);
	if (vcpu == -1) {
		perror("KVM_CREATE_VCPU");
		goto error;
	}

	if (!get_reg_list(vcpu, &regs, &regs_size)) {
		fputs("Strange, KVM_GET_REG_LIST succeeded before KVM_VCPU_INIT!\n",
		      stderr);
			
		goto error;
	}

	if (ioctl(vcpu, KVM_ARM_VCPU_INIT, &init)) {
		perror("KVM_ARM_VCPU_INIT");
		goto error;
	}

	if (get_reg_list(vcpu, &regs, &regs_size))
		goto error;

	assert(1 <= -1ULL >> 32);
	assert(ULONG_MAX >= (1ULL << 32) - 1);
	for (i = 0; i < regs->n; ++i) {
		size_t size;
		char const *s1 = "OK", *s2 = "", *s3 = "";;

		size = (size_t)1 << ((regs->reg[i] & KVM_REG_SIZE_MASK) >>
				     KVM_REG_SIZE_SHIFT);
		if (size < 4 || size > 16) {
			s1 = "BADSIZE";
			fail = 1;
		} else {
			memset(&reg, 0, sizeof reg);

			reg.id = regs->reg[i];
			reg.addr = (__u64)&regdata;
			if (ioctl(vcpu, KVM_GET_ONE_REG, &reg)) {
				s1 = "FAIL (";
				s2 = strerror(errno);
				s3 = ")";
				fail = 1;
			}
		}

		printf("\t0x%.16lx\t%s%s%s\n",
		       (unsigned long)reg.id, s1, s2, s3);
	
	}

	if (ferror(stdout) || fflush(stdout))
		goto stdout_error;
	
	if (fail) {
		puts("FAIL");
		goto error;
	}

	if (puts("\nPASS") == EOF || fclose(stdout))
		goto stdout_error;

	return EXIT_SUCCESS;

stdout_error:
	fputs("I/O error", stderr);
error:
	return EXIT_FAILURE;
}
