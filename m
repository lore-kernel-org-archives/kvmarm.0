From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: Re: [PATCH v3 08/11] KVM: arm: implement dirty bit mechanism for debug registers
Date: Wed, 08 Jul 2015 18:50:22 +0800
Message-ID: <123AABA4-2C79-462D-91FC-56FB52DB972C@linaro.org>
References: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org> <1434969694-7432-9-git-send-email-zhichao.huang@linaro.org> <20150630092020.GP11332@cbox> <B3B5AB0D-020C-483D-A6DE-76E355865010@linaro.org> <20150703115611.GB14220@lvm> <5A7DE9A0-E7A6-40B0-80F9-896F7DED0E47@linaro.org> <20150707102405.GE23879@arm.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150707102405.GE23879@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <Marc.Zyngier@arm.com>, "alex.bennee@linaro.org" <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, "huangzhichao@huawei.com" <huangzhichao@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi, Will,

Are you happy with this?:

diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c

+bool hw_breakpoint_enabled(void)
+{
+    struct perf_event **slots;
+    int i;
+
+    slots = this_cpu_ptr(bp_on_reg);
+    for (i = 0; i < core_num_brps; i++) {
+        if (slots[i])
+            return true;
+    }
+
+    slots = this_cpu_ptr(wp_on_reg);
+    for (i = 0; i < core_num_wrps; i++) {
+        if (slots[i])
+            return true;
+    }
+
+    return false;
+}

It doesn't change any existing functions, and even doesn't add a new
variables, it just provide an indication for KVM, and it's low-overhead.

We will only call it upon guest entry, so there is also no race for it.


On July 7, 2015 6:24:06 PM GMT+08:00, Will Deacon <will.deacon@arm.com> wrote:
>On Tue, Jul 07, 2015 at 11:06:57AM +0100, Zhichao Huang wrote:
>> Chazy and me are talking about how to reduce the saving/restoring
>> overhead for debug registers.
>> We want to add a state in hw_breakpoint.c to indicate whether the
>host
>> enable any hwbrpts or not (might export a fuction that kvm can call),
>> then we can read this state from memory instead of reading from real
>> hardware registers, and to decide whether we need a world switch or
>> not.
>> Does it acceptable?
>
>Maybe, hard to tell without the code. There are obvious races to deal
>with
>if you use variables to indicate whether resources are in use -- why
>not
>just trap debug access from the host as well? Then you could keep track
>of
>the "owner" in kvm and trap accesses from everybody else.
>
>Will

-- 
Zhichao Huang
