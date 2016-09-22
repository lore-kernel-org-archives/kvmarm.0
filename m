From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/2] config: move x86 kvm_guest.config to a common locaton
Date: Thu, 22 Sep 2016 11:39:17 +0200
Message-ID: <20160922093917.GB9101@cbox>
References: <20160908184102.8592-1-robh@kernel.org>
 <CAL_JsqKe=N=VLDfVNJbb2rLWcT+UVJP2JNcdk4tSkSua0FXU_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAL_JsqKe=N=VLDfVNJbb2rLWcT+UVJP2JNcdk4tSkSua0FXU_Q@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 21, 2016 at 03:10:30PM -0500, Rob Herring wrote:
> On Thu, Sep 8, 2016 at 1:41 PM, Rob Herring <robh@kernel.org> wrote:
> > kvm_guest.config is useful for KVM guests on other arches, and nothing
> > in it appears to be x86 specific, so just move the whole file. Kbuild
> > will find it in either location.
> >
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > Cc: Christoffer Dall <christoffer.dall@linaro.org>
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > Cc: kvmarm@lists.cs.columbia.edu
> > Cc: kvm@vger.kernel.org
> 
No objections from my side, and this looks useful:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
