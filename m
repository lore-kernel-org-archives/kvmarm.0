From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 3/3] KVM: arm64: Implement accessors for vGIC CPU interface
 registers
Date: Tue, 01 Sep 2015 16:09:18 +0300
Message-ID: <010801d0e4b7$698757d0$3c960770$@samsung.com>
References: <cover.1440766141.git.p.fedin@samsung.com>
 <2857f7cad7c17109dfa3028f79af28893c0171ce.1440766141.git.p.fedin@samsung.com>
 <20150830165015.GE24113@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20150830165015.GE24113@cbox>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> Have you thought about proper locking/serializing of access to the GIC
> state in these accessor functions?  

 I am in the process of rewriting the whole thing, and i came to this point.
 What kind of locking  would you expect ? It's a CPU interface, it does not affect state of any
other vCPUs. And, since i am getting/setting its registers, i assume that the vCPU is not running.
Well, i added the check. What next?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


